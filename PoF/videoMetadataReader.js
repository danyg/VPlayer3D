(function(){
	var fs = require('fs');
	var p = requirejs('service!utils').toPath(requirejs('service!app').playlist[0].url);

	fs.open(p, 'r', function(err, fd){
console.log('OPEN', err);
		fs.fstat(fd, function(err,stat){
console.log('STAT', err, stat);
			var buffer = new Buffer(414),
				o = {}
			;
			fs.read(fd, buffer, 0, 414, (stat.size - 414), function(err, bytesRead, buffer){
console.log('READ', err);
				var capture = false,
					key = null,
					keyEnd = null,
					val = null
				;

				for(var i = 0; i < 1024; i++){
					if(buffer[i] === 0xA3){

						if( key !== null){
							value = buffer.toString('utf8', keyEnd+13, i-4);
							o[key] = value;
						}

						key = null;
						keyEnd = null;
						val = null;
						capture = 0;

						continue;
					}
					if(capture !== false){
						if(capture >= 1){
							if(buffer[i-2] === 0x44 && buffer[i-1] === 0x7A && buffer[i] === 0x83){
								key = buffer.toString('utf8', (i - capture)+1, i-2);
								keyEnd = i;

							}
						}
						capture++;
					}
				}

				console.log('ENDED', o);
			});

		});


	});

}())