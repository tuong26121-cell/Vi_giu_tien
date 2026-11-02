from pathlib import Path
import os,socket,subprocess,re,signal,json,threading
from http.server import BaseHTTPRequestHandler,HTTPServer
root=Path(__file__).resolve().parents[1]
def free_port():
 with socket.socket() as s:s.bind(('127.0.0.1',0));return s.getsockname()[1]
def run(port):
 env=os.environ.copy();env['TUTO_PREVIEW_PORT']=str(port)
 return subprocess.run(['node','.devcontainer/start-preview.mjs'],cwd=root,env=env,capture_output=True,text=True,timeout=30)
pid=None
try:
 port=free_port();first=run(port);assert first.returncode==0,first.stderr
 pid=int(re.search(r'preview PID: (\d+)',first.stdout).group(1))
 second=run(port);assert second.returncode==0,second.stderr
 assert 'already running' in second.stdout and 'preview PID:' not in second.stdout
 os.kill(pid,0)
 class Handler(BaseHTTPRequestHandler):
  def do_GET(self):self.send_response(200);self.end_headers();self.wfile.write(b'<html>Another service</html>')
  def log_message(self,*args):pass
 server=HTTPServer(('127.0.0.1',0),Handler)
 thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start()
 try:
  occupied=run(server.server_port);assert occupied.returncode!=0
  assert 'occupied by another service' in occupied.stderr
  assert thread.is_alive()
 finally:server.shutdown();server.server_close()
 invalid=run(0);assert invalid.returncode!=0 and 'must be between' in invalid.stderr
 print(json.dumps({'startup':'PASS','reuse_existing_preview':'PASS','unrelated_service_preserved':'PASS','invalid_port_rejected':'PASS','cleanup':'owned preview process stopped'}))
finally:
 if pid:
  try:os.killpg(pid,signal.SIGTERM)
  except ProcessLookupError:pass
