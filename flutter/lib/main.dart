import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const TutoApp()); }
const sea = Color(0xFF087EEB);
const ink = Color(0xFF112A4F);
String money(num value) {
  final n = value.round().abs().toString();
  final parts = <String>[];
  for (var i = n.length; i > 0; i -= 3) { parts.insert(0, n.substring(i - 3 < 0 ? 0 : i - 3, i)); }
  return '${value < 0 ? '-' : ''}${parts.join('.')} đ';
}

class Pocket {
  String id, name, emoji;
  int balance;
  Pocket(this.id, this.name, this.emoji, this.balance);
  Map<String,dynamic> toJson() => {'id':id,'name':name,'emoji':emoji,'balance':balance};
  factory Pocket.fromJson(Map<String,dynamic> j) => Pocket(j['id'] as String,j['name'] as String,j['emoji'] as String,(j['balance'] as num).toInt());
}
class Entry {
  String id, title, category, pocketId, type, date;
  int amount;
  Entry(this.id,this.title,this.category,this.pocketId,this.type,this.date,this.amount);
  Map<String,dynamic> toJson() => {'id':id,'title':title,'category':category,'pocketId':pocketId,'type':type,'date':date,'amount':amount};
  factory Entry.fromJson(Map<String,dynamic> j) => Entry(j['id'] as String,j['title'] as String,j['category'] as String,j['pocketId'] as String,j['type'] as String,j['date'] as String,(j['amount'] as num).toInt());
}
class Goal {
  String id, name, emoji;
  int target, saved;
  Goal(this.id,this.name,this.emoji,this.target,this.saved);
  Map<String,dynamic> toJson() => {'id':id,'name':name,'emoji':emoji,'target':target,'saved':saved};
  factory Goal.fromJson(Map<String,dynamic> j) => Goal(j['id'] as String,j['name'] as String,j['emoji'] as String,(j['target'] as num).toInt(),(j['saved'] as num).toInt());
}
class Wallet extends ChangeNotifier {
  final List<Pocket> pockets = [];
  final List<Entry> entries = [];
  final List<Goal> goals = [];
  bool loaded = false;
  int get total => pockets.fold(0,(int a,p) => a+p.balance);
  int sum(String type) => entries.where((e)=>e.type==type).fold(0,(int a,e)=>a+e.amount);
  String newId() => DateTime.now().microsecondsSinceEpoch.toString();
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final raw = prefs.getString('tuto_data_v1');
      if(raw == null) {
        pockets.addAll([Pocket('main','Túi chính','💧',0),Pocket('reserve','Dự phòng','💙',0)]);
      } else {
        final data = jsonDecode(raw) as Map<String,dynamic>;
        pockets.addAll((data['pockets'] as List).map((e)=>Pocket.fromJson(Map<String,dynamic>.from(e as Map))));
        entries.addAll((data['entries'] as List).map((e)=>Entry.fromJson(Map<String,dynamic>.from(e as Map))));
        goals.addAll((data['goals'] as List).map((e)=>Goal.fromJson(Map<String,dynamic>.from(e as Map))));
      }
    } catch (_) { pockets.clear(); entries.clear(); goals.clear(); pockets.add(Pocket('main','Túi chính','💧',0)); }
    loaded=true; notifyListeners();
  }
  Future<void> save() async {
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('tuto_data_v1',jsonEncode({'pockets':pockets.map((e)=>e.toJson()).toList(),'entries':entries.map((e)=>e.toJson()).toList(),'goals':goals.map((e)=>e.toJson()).toList()}));
  }
  Future<String?> addEntry(String title,String category,String pocketId,String type,int amount) async {
    if(amount<=0 || title.trim().isEmpty) return 'Nhập nội dung và số tiền hợp lệ';
    final p=pockets.where((p)=>p.id==pocketId).firstOrNull;
    if(p==null) return 'Không tìm thấy túi';
    if(type=='chi' && p.balance<amount) return 'Số dư túi không đủ';
    p.balance += type=='thu'?amount:-amount;
    entries.insert(0,Entry(newId(),title.trim(),category,pocketId,type,DateTime.now().toIso8601String(),amount));
    await save(); return null;
  }
  Future<String?> transfer(String from,String to,int amount) async {
    if(from==to || amount<=0) return 'Chọn hai túi khác nhau và số tiền hợp lệ';
    final a=pockets.where((p)=>p.id==from).firstOrNull;
    final b=pockets.where((p)=>p.id==to).firstOrNull;
    if(a==null || b==null) return 'Túi không tồn tại';
    if(a.balance<amount) return 'Số dư không đủ';
    a.balance-=amount; b.balance+=amount;
    entries.insert(0,Entry(newId(),'Chuyển ${a.name} → ${b.name}','Nội bộ',from,'chuyen',DateTime.now().toIso8601String(),amount));
    await save(); return null;
  }
  Future<String?> fundGoal(String id,String pocketId,int amount) async {
    final g=goals.where((x)=>x.id==id).firstOrNull;
    final p=pockets.where((x)=>x.id==pocketId).firstOrNull;
    if(g==null || p==null || amount<=0) return 'Dữ liệu không hợp lệ';
    if(p.balance<amount) return 'Số dư không đủ';
    p.balance-=amount; g.saved+=amount;
    entries.insert(0,Entry(newId(),'Góp mục tiêu ${g.name}','Tiết kiệm',pocketId,'muctieu',DateTime.now().toIso8601String(),amount));
    await save(); return null;
  }
}
class TutoApp extends StatefulWidget { const TutoApp({super.key}); @override State<TutoApp> createState()=>_TutoAppState(); }
class _TutoAppState extends State<TutoApp> {
  final wallet=Wallet();
  @override void initState(){super.initState(); wallet.load();}
  @override Widget build(BuildContext context)=>MaterialApp(title:'Tuto',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:sea),scaffoldBackgroundColor:const Color(0xFFEAF7FF),fontFamily:'Roboto',appBarTheme:const AppBarTheme(backgroundColor:Color(0xFFEAF7FF),foregroundColor:ink,centerTitle:true)),home:AnimatedBuilder(animation:wallet,builder:(context,_)=>wallet.loaded?Shell(wallet):const Scaffold(body:Center(child:CircularProgressIndicator()))));
}
class Shell extends StatefulWidget {final Wallet wallet; const Shell(this.wallet,{super.key}); @override State<Shell> createState()=>_ShellState();}
class _ShellState extends State<Shell> {
  int tab=0;
  @override Widget build(BuildContext context) {
    final pages=[HomePage(widget.wallet,go:(i)=>setState(()=>tab=i)),PocketsPage(widget.wallet),EntriesPage(widget.wallet),GoalsPage(widget.wallet),StatsPage(widget.wallet),TransferPage(widget.wallet)];
    return Scaffold(appBar:AppBar(title:Row(mainAxisSize:MainAxisSize.min,children:[const Text('💧 '),Text(['Tuto','Túi tiết kiệm','Ghi chép thu chi','Mục tiêu tiết kiệm','Biểu đồ tài chính','Chuyển tiền mô phỏng'][tab],style:const TextStyle(fontWeight:FontWeight.bold,fontSize:19))])),body:SafeArea(child:pages[tab]),bottomNavigationBar:NavigationBar(height:72,selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:const [NavigationDestination(icon:Icon(Icons.home_outlined),label:'Trang chủ'),NavigationDestination(icon:Icon(Icons.savings_outlined),label:'Túi tiền'),NavigationDestination(icon:Icon(Icons.receipt_long_outlined),label:'Thu chi'),NavigationDestination(icon:Icon(Icons.flag_outlined),label:'Mục tiêu'),NavigationDestination(icon:Icon(Icons.pie_chart_outline),label:'Thống kê'),NavigationDestination(icon:Icon(Icons.swap_horiz),label:'Chuyển')]));
  }
}
Widget panel(Widget child,{EdgeInsets? padding})=>Container(margin:const EdgeInsets.symmetric(vertical:7),padding:padding??const EdgeInsets.all(17),decoration:BoxDecoration(color:Colors.white.withValues(alpha:.90),borderRadius:BorderRadius.circular(22),boxShadow:[BoxShadow(color:sea.withValues(alpha:.09),blurRadius:16,offset:const Offset(0,6))]),child:child);
Widget heading(String s)=>Padding(padding:const EdgeInsets.symmetric(vertical:12),child:Text(s,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800,color:ink)));
Widget action(String label,VoidCallback onPressed)=>SizedBox(width:double.infinity,child:FilledButton(onPressed:onPressed,style:FilledButton.styleFrom(backgroundColor:sea,padding:const EdgeInsets.all(15)),child:Text(label)));
void notice(BuildContext context,String message)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(message)));
Future<String?> askText(BuildContext context,String title,{String hint=''}) async {
  final c=TextEditingController();
  final result=await showDialog<String>(context:context,builder:(ctx)=>AlertDialog(title:Text(title),content:TextField(controller:c,autofocus:true,decoration:InputDecoration(hintText:hint)),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Hủy')),FilledButton(onPressed:()=>Navigator.pop(ctx,c.text.trim()),child:const Text('Lưu'))])); c.dispose(); return result;
}
Future<int?> askAmount(BuildContext context,String title) async {
  final t=await askText(context,title,hint:'Ví dụ: 500000');
  return t==null?null:int.tryParse(t.replaceAll(RegExp(r'[^0-9]'),''));
}
class HomePage extends StatelessWidget {
  final Wallet w; final void Function(int) go; const HomePage(this.w,{required this.go,super.key});
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[const Text('Xin chào! 👋',style:TextStyle(fontSize:25,fontWeight:FontWeight.bold,color:ink)),const Text('Cùng quản lý và giữ tiền thật hiệu quả nhé!'),Container(margin:const EdgeInsets.only(top:18,bottom:12),padding:const EdgeInsets.all(24),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF43C7FF),Color(0xFF0560DC)]),borderRadius:BorderRadius.circular(26)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Tổng số dư các túi',style:TextStyle(color:Colors.white)),const SizedBox(height:12),Text(money(w.total),style:const TextStyle(fontSize:31,fontWeight:FontWeight.bold,color:Colors.white)),const SizedBox(height:8),const Text('💧  Tiền mô phỏng · lưu trên máy',style:TextStyle(color:Colors.white))])),Wrap(spacing:8,runSpacing:8,children:[for(final item in [(1,'💰 Túi tiền'),(2,'🧾 Thu chi'),(3,'🎯 Mục tiêu'),(5,'✈️ Chuyển tiền')]) ActionChip(label:Text(item.$2),onPressed:()=>go(item.$1))]),heading('Tổng quan tài chính'),panel(Column(children:[rowInfo('Thu nhập',money(w.sum('thu')),Colors.green),rowInfo('Chi tiêu',money(w.sum('chi')),Colors.red),rowInfo('Đã góp mục tiêu',money(w.goals.fold<int>(0,(a,g)=>a+g.saved)),sea)])),heading('Các túi của bạn'),...w.pockets.take(4).map((p)=>panel(rowInfo('${p.emoji} ${p.name}',money(p.balance),ink)))]);
}
Widget rowInfo(String a,String b,Color c)=>Padding(padding:const EdgeInsets.symmetric(vertical:8),child:Row(children:[Expanded(child:Text(a,style:const TextStyle(fontWeight:FontWeight.w600))),Text(b,style:TextStyle(color:c,fontWeight:FontWeight.bold))]));
class PocketsPage extends StatelessWidget {final Wallet w;const PocketsPage(this.w,{super.key});
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[panel(Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Tổng tiền trong các túi'),heading(money(w.total))])),...w.pockets.map((p)=>panel(ListTile(leading:Text(p.emoji,style:const TextStyle(fontSize:29)),title:Text(p.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(money(p.balance))))),const SizedBox(height:15),action('＋ Tạo túi mới',() async {final name=await askText(context,'Tên túi mới',hint:'Ví dụ: Du lịch');if(name!=null && name.isNotEmpty){w.pockets.add(Pocket(w.newId(),name,'💰',0));await w.save();}})]);
}
class EntriesPage extends StatelessWidget {final Wallet w;const EntriesPage(this.w,{super.key});
 Future<void> add(BuildContext context,String type) async {final title=await askText(context,type=='thu'?'Nội dung thu nhập':'Nội dung chi tiêu');if(title==null||title.isEmpty||!context.mounted)return;final amount=await askAmount(context,'Số tiền');if(amount==null||!context.mounted)return;final pocket=await choosePocket(context,w.pockets,'Chọn túi');if(pocket==null||!context.mounted)return;final error=await w.addEntry(title,type=='thu'?'Thu nhập':'Chi tiêu',pocket,type,amount);if(context.mounted)notice(context,error??'Đã lưu giao dịch');}
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[panel(Column(children:[rowInfo('Tổng thu',money(w.sum('thu')),Colors.green),rowInfo('Tổng chi',money(w.sum('chi')),Colors.red)])),Row(children:[Expanded(child:FilledButton.icon(onPressed:()=>add(context,'thu'),icon:const Icon(Icons.add),label:const Text('Ghi thu'))),const SizedBox(width:10),Expanded(child:OutlinedButton.icon(onPressed:()=>add(context,'chi'),icon:const Icon(Icons.remove),label:const Text('Ghi chi')))]),heading('Lịch sử giao dịch'),if(w.entries.isEmpty)panel(const Text('Chưa có giao dịch nào.')),...w.entries.map((e)=>panel(ListTile(leading:Icon(e.type=='thu'?Icons.arrow_downward:e.type=='chi'?Icons.arrow_upward:Icons.swap_horiz,color:e.type=='thu'?Colors.green:sea),title:Text(e.title),subtitle:Text('${e.category} · ${e.date.substring(0,10)}'),trailing:Text('${e.type=='thu'?'+':e.type=='chi'?'-':''}${money(e.amount)}',style:const TextStyle(fontWeight:FontWeight.bold)))))]);
}
Future<String?> choosePocket(BuildContext context,List<Pocket> pockets,String title,{String? except})=>showModalBottomSheet<String>(context:context,builder:(ctx)=>SafeArea(child:ListView(shrinkWrap:true,children:[ListTile(title:Text(title,style:const TextStyle(fontWeight:FontWeight.bold))),...pockets.where((p)=>p.id!=except).map((p)=>ListTile(title:Text('${p.emoji} ${p.name}'),subtitle:Text(money(p.balance)),onTap:()=>Navigator.pop(ctx,p.id)))])));
class GoalsPage extends StatelessWidget {final Wallet w;const GoalsPage(this.w,{super.key});
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[...w.goals.map((g)=>panel(Column(crossAxisAlignment:CrossAxisAlignment.start,children:[heading('🎯 ${g.name}'),rowInfo('Đã tiết kiệm',money(g.saved),sea),rowInfo('Mục tiêu',money(g.target),ink),LinearProgressIndicator(value:g.target<=0?0:(g.saved/g.target).clamp(0.0,1.0),minHeight:9,borderRadius:BorderRadius.circular(9)),const SizedBox(height:12),action('Góp tiền vào mục tiêu',()async{final a=await askAmount(context,'Số tiền muốn góp');if(a==null||!context.mounted)return;final p=await choosePocket(context,w.pockets,'Lấy tiền từ túi');if(p==null||!context.mounted)return;final error=await w.fundGoal(g.id,p,a);if(context.mounted)notice(context,error??'Đã góp tiền');})])),const SizedBox(height:12),action('＋ Thêm mục tiêu',()async{final name=await askText(context,'Tên mục tiêu',hint:'Ví dụ: Mua laptop');if(name==null||name.isEmpty||!context.mounted)return;final amount=await askAmount(context,'Số tiền mục tiêu');if(amount==null||amount<=0||!context.mounted)return;w.goals.add(Goal(w.newId(),name,'🎯',amount,0));await w.save();})]);
}
class StatsPage extends StatelessWidget {final Wallet w;const StatsPage(this.w,{super.key});
 @override Widget build(BuildContext context){final inc=w.sum('thu'),exp=w.sum('chi'),max=(inc>exp?inc:exp);return ListView(padding:const EdgeInsets.all(18),children:[heading('Biểu đồ thu và chi'),panel(Column(crossAxisAlignment:CrossAxisAlignment.start,children:[rowInfo('Thu nhập',money(inc),Colors.green),LinearProgressIndicator(value:max==0?0:inc/max,minHeight:22,borderRadius:BorderRadius.circular(10),color:Colors.green),const SizedBox(height:24),rowInfo('Chi tiêu',money(exp),Colors.red),LinearProgressIndicator(value:max==0?0:exp/max,minHeight:22,borderRadius:BorderRadius.circular(10),color:Colors.red)])),heading('Phân loại chi tiêu'),..._categories(w).entries.map((e)=>panel(rowInfo(e.key,money(e.value),sea))),heading('Tổng quan'),panel(Column(children:[rowInfo('Số dư hiện tại',money(w.total),sea),rowInfo('Tổng mục tiêu',money(w.goals.fold<int>(0,(a,g)=>a+g.target)),ink),rowInfo('Số giao dịch','${w.entries.length}',ink)]))]);}
 Map<String,int> _categories(Wallet w){final result=<String,int>{};for(final e in w.entries.where((e)=>e.type=='chi')){result[e.category]=(result[e.category]??0)+e.amount;}return result;}
}
class TransferPage extends StatefulWidget {final Wallet w;const TransferPage(this.w,{super.key});@override State<TransferPage> createState()=>_TransferPageState();}
class _TransferPageState extends State<TransferPage>{String? from,to;final amount=TextEditingController();@override void dispose(){amount.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[panel(const Text('Chỉ chuyển tiền mô phỏng giữa các túi Tuto. Không gửi tiền tới ngân hàng hay người khác.',style:TextStyle(color:ink))),panel(Column(children:[ListTile(title:const Text('Từ túi'),subtitle:Text(widget.w.pockets.where((p)=>p.id==from).firstOrNull?.name??'Chọn túi nguồn'),trailing:const Icon(Icons.keyboard_arrow_down),onTap:()async{final id=await choosePocket(context,widget.w.pockets,'Túi nguồn');if(mounted)setState(()=>from=id);}),const Icon(Icons.swap_vert,color:sea),ListTile(title:const Text('Đến túi'),subtitle:Text(widget.w.pockets.where((p)=>p.id==to).firstOrNull?.name??'Chọn túi đích'),trailing:const Icon(Icons.keyboard_arrow_down),onTap:()async{final id=await choosePocket(context,widget.w.pockets,'Túi đích',except:from);if(mounted)setState(()=>to=id);}),TextField(controller:amount,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Số tiền (VND)',hintText:'500000')),const SizedBox(height:20),action('Chuyển tiền mô phỏng',()async{final a=int.tryParse(amount.text.replaceAll(RegExp(r'[^0-9]'),''));if(from==null||to==null||a==null){notice(context,'Vui lòng chọn hai túi và nhập số tiền');return;}final error=await widget.w.transfer(from!,to!,a);if(!mounted)return;notice(context,error??'Chuyển nội bộ thành công');if(error==null)amount.clear();})]))]);}
}
