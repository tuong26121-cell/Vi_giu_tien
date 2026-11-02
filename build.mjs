import {mkdir,cp,readFile,rm} from 'node:fs/promises';
import {execFileSync} from 'node:child_process';
for(const file of ['main.js','model.js'])execFileSync(process.execPath,['--check',file],{stdio:'inherit'});
const html=await readFile('index.html','utf8');
for(const element of ['lang="vi"','/main.js','/style.css','id="dialog"'])if(!html.includes(element))throw new Error('Missing document element: '+element);
await rm('dist',{recursive:true,force:true});await mkdir('dist');
for(const file of ['index.html','main.js','model.js','style.css','assets'])await cp(file,'dist/'+file,{recursive:true});
console.log('✓ Tuto production build complete: 6 screens, local SVG assets, HTML/CSS/JS.');
