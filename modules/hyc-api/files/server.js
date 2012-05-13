var net = require('net'),
    spawn = require('child_process').spawn,
    fs = require('fs'),
    available = true;
function date() {
  var _date = new Date();
  return _date.getDate() + "/" + (_date.getMonth()+1) + "/" + _date.getFullYear() + " " + _date.getHours() + ":" + _date.getMinutes();
};

function trim (str) {
	str = str.replace(/^\s+/, '');
	for (var i = str.length - 1; i >= 0; i--) {
		if (/\S/.test(str.charAt(i))) {
			str = str.substring(0, i + 1);
			break;
		}
	}
	return str;
}

var server = net.createServer({ allowHalfOpen: false });
server.listen(8124, function() { //'listening' listener
  console.log('['+ date() +'] server bound');
});
server.on('connection',function(c) {
  c.on('end', function() {
    console.log('['+ date() + '] client disconnected');
  });
  c.on('connect', function() {
    console.log('['+ date() + '] client connected');
  });
  c.on('data', function(buffer) {
    var data = buffer.toString('ascii');
    data = data.split("\n");
    console.log('['+ date() + '] Data received : '+ data);
    data = data[0].split(" ");
    switch(data[0]) {
      case 'ping':
        c.write('pong\n');
        c.end();
        break;
      case 'date':
        c.write(date()+'\n');
        c.end();
        break;
      case 'create':
        if(!available)
        {
            c.end('Unavailable');
            break;
        }
        available = false;
        cmd = spawn('/opt/api/create_image.sh',['-n',data[1], '-m', data[2], '-s', data[3], '-o', data[4], '-b', data[5], '-d', data[6] ]);
        sortie(cmd,c);
        cmd.on('exit', function() {
            available = true;
            c.end();
        });
        break;
      case 'delete':
        delete_image(data,c);
        break;
      case 'start':
        start(data,c);
        break;
      case 'stop':
        stop(data,c);
        break;
      case 'password':
        password(data,c);
        break;
      default:
        c.write('Unknown command !');
        break;
    }
  });
});
function sortie(cmd,c)
{
  cmd.stdout.on('data',function (data) {
    c.write(data); 
  });
  cmd.stderr.on('data',function (data) {
    console.log('['+date()+'] stderr : '+data);
  });
}
var start = function(data,c)
{
    if(!data[1] || data[1] < 1)
    {
        console.log('['+date()+'] Invalid param');
        c.end('Error');
    }
    else
    {
        cmd = spawn('xm',['create', "vm"+data[1]+".cfg" ]);
        sortie(cmd,c);
        cmd.on('exit', function() {
            c.end();
        });
    }
}
var stop = function(data,c)
{
    if(!data[1] || data[1] < 1)
    {
        console.log('['+date()+'] Invalid param');
        c.end('Error');
    }
    else
    {
        cmd = spawn('xm',['destroy', "vm"+data[1] ]);
        sortie(cmd,c);
        cmd.on('exit', function() {
            c.end();
        });
    }
}
var delete_image = function(data,c)
{
    if(!data[1] || data[1] < 1)
    {
        console.log('['+date()+'] Invalid param');
        c.end('Error');
    }
    else
    {
        cmd = spawn('xm',['destroy', "vm"+data[1] ]);
        sortie(cmd,c);
        cmd.on('exit', function() {
            cmd = spawn('xen-delete-image',["vm"+data[1] ]);
            sortie(cmd,c);
            cmd.on('exit', function() {
                fs.unlink("/opt/firewall/vm/"+data[1], function (err) {
                  if (err) {
                    console.log('['+date()+'] Can\'t delete firewall file.');
                    c.end('Error');
                    } else { c.end(); }
                });
            });
        });
    }
}

var password = function(data,c)
{
    if(!data[1] || data[1] < 1)
    {
        console.log('['+date()+'] Invalid param');
        c.end('Error');
    }
    else
    {
        var passwd;
        cmd = spawn('pwgen',['-s','12','1']);
        cmd.stdout.on('data',function (data) {
            c.write(data);
            passwd = trim(data+"");
        });
        cmd.on('exit', function() {
            cmd = spawn('ssh',['root@10.10.10.'+data[1],'echo \"minecraft:'+passwd+'\" | chpasswd']);
            sortie(cmd,c);
            cmd.on('exit', function() {
                c.end();
            });
        });
    }
}
