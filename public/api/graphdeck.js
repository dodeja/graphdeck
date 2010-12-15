function Graphdeck(datasource) {
	this.datasource = datasource;
	
	this.render = function () {
		if($()) {
			$.ajax({
				url: datasource,
				dataType: 'jsonp',
				success: function(data) {
					if(data['tsd'].length > 0) {
						var tsd = "";
						var min = 0;
						var max = data['tsd'][0]['value'];						
						var t = 0;
						for(var i = data['from']; i <= data['to']; i += data['duration']) {
							if(t < data['tsd'].length) {
								if(data['tsd'][t]['timestamp'] == i) {
									var value = data['tsd'][t]['value']; // console.log(i + ':' + value);
									if(value < min) {
										min = value;
									}
									if(value > max) {
										max = value;
									}
									tsd += value;
									t += 1;
								} else {
									tsd += '_'; // console.log(i);
								}
							} else {
								tsd += '_'; // console.log(i);
							}
							if(i < data['to']) {
								tsd += ',';
							}
						}
//						console.log('Min: ' + min);
//						console.log('Max: ' + max);
//						console.log('TSD: ' + tsd);
						var imgsrc = 'http://chart.apis.google.com/chart?chxr=0,'+min+','+max+'&chxt=y&chs=600x200&cht=lc&chds='+min+','+max+'&chd=t:'+tsd+'&chg=14.3,-1,1,1&chls=1&chm=B,cccccc,0,0,0';
//						console.log('Image source: ' + imgsrc);
						$('#graphdeck').html('<img src="' + imgsrc + '"/>');
//						console.log('Load was performed.');
					} else {
						console.log("No data was retrieved.");
					}
			  	}
			});
		} else {
			console.log("No jQuery support.")
		}
		// "http://chart.apis.google.com/chart?chxr=0,#{min},#{max}&chxt=y&chs=600x200&cht=lc&chds=#{min},#{max}&chd=t:#{tsd}&chg=14.3,-1,1,1&chls=1&chm=B,cccccc,0,0,0"
		/*
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4 && xmlhttp.status==200) {
				var response = xmlhttp.responseText;
				var min = 0;
				var max = 0;
				var tsd = "";
				
				for(t in response) {
					if(response.t < min) {
						min = response.t;
					}
					if(response.t > max) {
						max = response.t;
					}
					tsd += response.t;
					tsd += ",";
				}
				document.getElementById('graphdeck').innerHTML = tsd;
			}
		};
		
		console.log("rendering!");
		
		xmlhttp.open("GET",datasource,true);
		xmlhttp.send();
		*/
	};
}

new Graphdeck(datasource).render();