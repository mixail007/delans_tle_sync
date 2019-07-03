&НаСервере
Функция СформироватьКарту(ОтображатьПредопределенныеОбласти, ВидОтображения, Объект) Экспорт 
	//ЭР Сальник К.А. 13.04.2018 11:34:00 {
	
	//todo: переделать, координаты должны определяться 1 раз, при задании центра карты в стартовых настройках
	//сделать проверку, если они не заполенны, то определять и заполнять
	ЦентрКарты = ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(ПредопределенноеЗначение("Перечисление.ES_ВидыСтартовыхНастроек.ОсновнойГород"));
	КоординатыЦентра = "55.7509, 37.6165";
	Если ЗначениеЗаполнено(ЦентрКарты) Тогда
		СтруктураКоординат = ES_YandexMaps.ГеокодированияПолучитьКоординаты(ЦентрКарты);
		КоординатыЦентра= ""+СтруктураКоординат.Долгота+"," + СтруктураКоординат.Широта;
	КонецЕсли;

	ТекстHTML = Новый ТекстовыйДокумент;	
	
	
	ТекстHTML = "<!DOCTYPE html>
			|<html>
			|<head>
			//|<meta http-equiv=""X-UA-Compatible"" content=""chrome=2"" />
			|<meta http-equiv=""X-UA-Compatible"" content=""IE=5"" />
			|
			|	<link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.2/leaflet.css"" />
			|   <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.3.2/leaflet.draw.css""/>
			|
			|	<script src=""https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.2/leaflet.js""></script>
			|	<script src=""http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js""></script>
			|	<script src=""https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.3.2/leaflet.draw.js""></script>
			|	<script type=""text/javascript"">
        	|	window.onerror = myOnError;
        	|	function myOnError(msg, url, lno) {return true}
    		|	</script> 
			|	<style>
			|		#map {
    		|			width: 100%;
    		|			height: 100%;
			|		}
			|		.my-div-icon {
			|	        font-weight: bold;
			|			white-space: nowrap;
			|			font-size: 110%; 
			|		}
			|	</style>
			|</head>
			|<body>
			|	<div id=""map""></div>
			|		<script>
			|
			|	function getOrder(){
			|		var ord = order;
			|		order = """";
			|		return ord;
			|	}
			|	function getLabel(){
			|		var lab = label;
			|		label = false;
			|		return lab;
			|	}
			|	
			|
			|	function setOrder(new_label, new_order){
			|		if (markers[new_order] != null){
			|  		markers[new_order].openPopup();
			|		var button = document.getElementById(new_order);
			|		if (new_label){
			|			button.style.background = ""green"";
			|			markers[new_order].closePopup();
			|			markers[new_order].setIcon(createIcon(""green"", markers[new_order].options.alt));
			|			markers[new_order]._icon.id = ""green""; 
			|		}
			|		else { 
			|			button.style.background = ""red"";
			|			markers[new_order].closePopup();
			|			markers[new_order].setIcon(createIcon(""red"", markers[new_order].options.alt));
			|			markers[new_order]._icon.id = ""red""; 

			|		}
			|		}
			|	
			|	}
			|   function getList(array){
			|		var new_array = [];
			|		for (var i = 0; i < array.length; i++){
			|			new_array[i] = {
			|				code: array[i].editing._leaflet_id,
			|				fillcolor: array[i].options.fillColor,
			|				color: array[i].options.color,
			|				coord: array[i]._latlngs,
			|				title: array[i].options.label			
			|			};
			|		}
			|		return new_array;
			|	}
			|
			|
			|	function saveToEdit(layer){
			|		if (typeof layer.editing._leaflet_id == ""string""){
			|				if (edited.length == 0){
			|		
			|					edited[0] = layer;
			|		
			|				}
			|				else {
			|					var changed = false;
			|					for (var i = 0; i < edited.length; i++) {
			|						if (edited[i].editing._leaflet_id == layer.editing._leaflet_id){			
			|							edited[i] = layer;
			|							changed = true;
			|							break;
			|						}
			|					}
			|					if (! changed)
			|					edited[edited.length] = layer;
			|				}
			|			}
			|			else{
			|				for (var i = 0; i < created.length; i++) {
			|					if (created[i].editing._leaflet_id == layer.editing._leaflet_id){			
			|						created[i] = layer; 
			|						break;
			|					}
			|				}
			|			}
			|	}
			|
    		|		var map = L.map('map',{
    		|		center: ["+КоординатыЦентра+"],
    		|		zoom: 10
    		|		});
			|
    		|		L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    		|		attribution: '&copy; <a href=""http://osm.org/copyright"">OpenStreetMap</a> contributors'
    		|		}).addTo(map);
			|
			|       var editableLayers = new L.FeatureGroup();";
		Если ОтображатьПредопределенныеОбласти = Истина Тогда
		
	        КоличествоЗон = 0;
			Зоны = ПолучитьЗоны(КоличествоЗон);
			ТекстHTML = ТекстHTML + Символы.ПС + Зоны;
		КонецЕсли;
		
			ТекстHTML = ТекстHTML + Символы.ПС + "
			|
			|		map.addLayer(editableLayers);
			|
			|		var selected = [];
			|		
			|		var edited = [];
		    |
			|		var deleted = [];
		    |
			|		var created = [];
			|
			|		var status =  0;
			|
			|		var MyCustomMarker = L.Icon.extend({
			|			options: {
			|			iconSize: [40, 41],
			|			iconAnchor: [12, 41],
			|			popupAnchor: [1, -34],
			|			shadowSize: [41, 41],
			|			iconUrl: 'https://cdn2.iconfinder.com/data/icons/IconsLandVistaMapMarkersIconsDemo/256/MapMarker_PushPin_Right_Pink.png'
 			|
			|			}
			|		});
			|
			|      	var options = {
			|			position: 'topright',
			|				draw: {
			|					polyline: false,
			|					polygon: {
			|						allowIntersection: false,
			|						drawError: {
			|							color: '#e1e100' , 
			|							message: '<strong>Oh snap!<strong> you can\'t draw that!' 
			|						},
			|						shapeOptions: {
			|							color: '#f357a1'
			|						}
			|					},
			|					circle: false,
			|					rectangle: false,
			|					marker: false			
			|			},
			|			edit: {
			|				featureGroup: editableLayers //REQUIRED!!
			|			}
			|		};
		    |
			|
			|
			|		var drawControl = new L.Control.Draw(options);
			|		map.addControl(drawControl);
            |
			|	map.on('draw:edited', function (e) {
			|		var layers = e.layers;
			|		layers.eachLayer(function (layer) {
			|			if (typeof layer.editing._leaflet_id == ""string""){
			|				if (edited.length == 0){
			|			
			|					edited[0] = layer;
			|			
			|				}
			|				else {
			|					var changed = false;
			|					for (var i = 0; i < edited.length; i++) {
			|						if (edited[i].editing._leaflet_id == layer.editing._leaflet_id){			
			|							edited[i] = layer;
			|							changed = true;
			|							break;
			|						}
			|					}
			|					if (! changed)
			|					edited[edited.length] = layer;
			|				}
			|			}
			|			else{
			|				for (var i = 0; i < created.length; i++) {
			|					if (created[i].editing._leaflet_id == layer.editing._leaflet_id){			
			|						created[i] = layer; 
			|						break;
			|					}
			|				}
			|			}
			|		
			|		});
			|	});
			|		map.on('draw:created', function (e){
			|			var type = e.layerType,
			|			layer = e.layer;";
			ТекстHTML = ТекстHTML + Символы.ПС + "var container = $('<div />');
			|	container.on('click', '#1', function() { var button = document.getElementById(1); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#2', function() { var button = document.getElementById(2); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#3', function() { var button = document.getElementById(3); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#4', function() { var button = document.getElementById(4); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#5', function() { var button = document.getElementById(5); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#6', function() { var button = document.getElementById(6); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#7', function() { var button = document.getElementById(7); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#8', function() { var button = document.getElementById(8); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#9', function() { var button = document.getElementById(9); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#10', function() { var button = document.getElementById(10); bColor = button.style.background.replace(/['""]/g, ''); layer.setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(layer); });
			|	container.on('click', '#200', function() { var title = document.getElementById(100).value; if (title) { document.getElementById(300).innerHTML = title; document.getElementById(100).value = """"; layer.setStyle({label: title}); saveToEdit(layer); } });
			|	container.on('click', '#400', function() { status = 1; selectAll(layer);  created.splice(find(layer), 1); });
			|	container.html(""<h3><span id = 300>Зона "" + layer.editing._leaflet_id + ""</span><button id = 400 style = \""position: absolute; right: 20\"">Отметить все</button></h3>"" + ""<div>Наименование: <input type = \""text\"" id = 100 value = \""\""><button id = 200>OK</button></div>"" +
			|	""<button id = 1 style = \""background: #9400D3; width: 25; height: 25\"";></button><button id = 2 style = \""background: #FF8C00; width: 25; height: 25\"";></button>"" +  
			|	""<button id = 3 style = \""background: blue; width: 25; height: 25\"";></button><button id = 4 style = \""background: aqua; width: 25; height: 25\"";></button>"" +
			|	""<button id = 5 style = \""background: lime; width: 25; height: 25\"";></button><button id = 6 style = \""background: yellow; width: 25; height: 25\"";></button>"" +
			|	""<button id = 7 style = \""background: red; width: 25; height: 25\"";></button><button id = 8 style = \""background: #A9A9A9; width: 25; height: 25\"";></button>""+
			|	""<button id = 9 style = \""background: #FF1493; width: 25; height: 25\"";></button><button id = 10 style = \""background: green; width: 25; height: 25\"";></button>"");
			|	layer.setStyle({label: ""Зона "" + layer.editing._leaflet_id});			
			|	layer.bindPopup(container[0], { maxWidth : 300 });
			|			editableLayers.addLayer(layer);
			|		
			|			created[created.length] = layer;
			|		
			|		}); 
		    |
			|
			|	function find(layer) {
    		|		for (var i = 0; i < created.length; i++) {
        	|			if (created[i] == layer) {
            |				return i;
        	|			}
    		|		}
    		|	return -1;
			|	}
			|
			|	function selectAll(layer){
			|		selected[0] = layer;
			|		for(var i = 1, j = 1; i < markers.length; i++){
			|			if (isInPoly(layer._latlngs, markers[i]._latlng)){
			|				var color;
			|				var icon = markers[i]._icon.id;
			|				var button = document.getElementById(i);
			|				if (icon == 'red'){
			|					color = true;
			|				}else{
			|					color = false;
			|				}
			|				 var marker = {
			|					number: i,
			|					label: color
			|				};
			|				selected[j] = marker;
			|				j++;	
			|			}
		    |
			|		}
			|		status = 2;
			|		
		    |
			|	}
			|
			|		map.on('draw:deleted', function(e) {
			|			var layers = e.layers;
			|			layers.eachLayer(function(layer) {
			|				if (typeof layer.editing._leaflet_id == ""string""){
			|					deleted[deleted.length] = layer;
			|						for (var i = 0; i < edited.length; i++) {
			|							if (edited[i].editing._leaflet_id == layer.editing._leaflet_id){			
			|								edited.splice(i, 1);
			|								break;
			|							}
			|						}
			|				}
			|				else{
			|					for (var i = 0; i < created.length; i++) {
			|						if (created[i].editing._leaflet_id == layer.editing._leaflet_id){			
			|							created.splice(i, 1);
			|							break;
			|						}
			|					}
			|				}
			|			});
			|		});
			|
			|		drawControl.setDrawingOptions({
			|			rectangle: {
			|				shapeOptions: {
			|					color: '#0000FF'
			|				}
			|			}
			|		});
		    |
			|		/*var greenIcon = new L.Icon({
		  	|			iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png',
		  	|			shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  	|			iconSize: [25, 41],
		  	|			iconAnchor: [12, 41],
		  	|			popupAnchor: [1, -34],
		  	|			shadowSize: [41, 41]
			|		}); */
			|
			|
			|		var blueIcon = new L.Icon({
		  	|			iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png',
		  	|			shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  	|			iconSize: [25, 41],
		  	|			iconAnchor: [12, 41],
		  	|			popupAnchor: [1, -34],
		  	|			shadowSize: [41, 41]
			|		});
			|		
			|
			|		function createIcon(color, order){
			|			if (color == ""green""){
			|				var greenIcon = new L.divIcon({
			|					className: 'my-div-icon',
			|					iconAnchor: [10, 60],
			|					html: '<div>&#160<span style = ""background: #C3F8D2; padding: 2px; height: 20px; filter: alpha(opacity=80); "">' + order + '</span><br><img src=""https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png"" width=""25"" height=""41""></div>'
			|	
			|				});
			|			return greenIcon;
			|			} else {
			|				if (color == ""blue""){
			|                   var blueIcon = new L.divIcon({
			|					className: 'my-div-icon',
			|					iconAnchor: [10, 60],
			|					html: '<div>&#160<span style = ""background: #C3D7F8; padding: 2px; height: 20px; filter: alpha(opacity=80); "">' + order + '</span><br><img src=""https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png"" width=""25"" height=""41""></div>'
			|	
			|					});
			|					return blueIcon;
			|				}
			|				else{
			|					var redIcon = new L.divIcon({
			|					className: 'my-div-icon',
			|					iconAnchor: [10, 60],
			|					html: '<div>&#160<span style = ""background: #F8C6C3; padding: 2px; height: 20px; filter: alpha(opacity=80); "">' + order + '</span><br><img src=""https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png"" width=""25"" height=""41""></div>'
			|	
			|					});
			|					return redIcon;
			|				}
			|			}
		    |
			|		}
			|
			|		/*var redIcon = new L.Icon({
			|			iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
			|			shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
			|			iconSize: [25, 41],
			|			iconAnchor: [12, 41],
			|			popupAnchor: [1, -34],
			|			shadowSize: [41, 41]
			|		}); */
			|
			|		var markers = [];
			|		var plans = [];
			|		var order = """";
			|		var label = false;";
			Если ВидОтображения = 1 или ВидОтображения = 3 Тогда
	        	ТекстHTML = ТекстHTML  + ДобавитьЗаказы(Объект);
			КонецЕсли;
			Если ВидОтображения = 2 или ВидОтображения = 3 Тогда
	        	ТекстHTML = ТекстHTML  + ДобавитьПланы(Объект);
			КонецЕсли;
			ТекстHTML = ТекстHTML  + Символы.ПС + "function MIN(a,b){return (a<b)?a:b;}
				|	function MAX(a,b){return (a>b)?a:b;}
                |
				|	function isInPoly(polygon,point)
				|	{
				|		var i=1,N=polygon.length,isIn=false,
				|			p1=polygon[0],p2;
				|		
				|		for(;i<=N;i++)
				|		{
				|			p2 = polygon[i % N];
				|			if (point.lng > MIN(p1.lng,p2.lng)) 
				|			{
				|				if (point.lng <= MAX(p1.lng,p2.lng)) 
				|				{
				|					if (point.lat <= MAX(p1.lat,p2.lat)) 
				|					{
				|						if (p1.lng != p2.lng) 
				|						{
				|							xinters = (point.lng-p1.lng)*(p2.lat-p1.lat)/(p2.lng-p1.lng)+p1.lat;
				|							if (p1.lat == p2.lat || point.lat <= xinters)
				|								isIn=!isIn;
				|						}
				|					}
				|				}
				|			}
				|			p1 = p2;
				|		}
				|		return isIn;
				|	}
				|
				|
				|	function getSelected(){ 
				|		if (status == 1){
				|			while (status != 2){ 
				|			} 
				|		}
				|		if(selected.length > 0){ 
				|			var sel = selected;
				|			for (var i = 1; i < sel.length; i++){
				|				markers[sel[i].number].openPopup();
				|				var button = document.getElementById(sel[i].number);
				|					if (button.style.background == 'red'){
				|						button.style.background = ""green"";
				|						markers[sel[i].number].closePopup();
				|						markers[sel[i].number].setIcon(createIcon(""green"", markers[sel[i].number].options.alt));
				|						markers[sel[i].number]._icon.id = ""green""; 
				|					}else{
				|						button.style.background = ""red"";
				|						markers[sel[i].number].closePopup();
				|						markers[sel[i].number].setIcon(createIcon(""red"", markers[sel[i].number].options.alt));
				|						markers[sel[i].number]._icon.id = ""red""; 
				|					}
				|			}
				|				selected = [];
				|			    editableLayers.removeLayer(sel[0]);
				|				sel[0] = """";
				|				status = 0;
				|				return sel;
				|	}
				|	}
				|
				|
				|function getPointsOfPolygon() {
				|	var PolygonsAndPoints = []; 
				|	count = 1;
				|	editableLayers.eachLayer(function (layer) {
				|	points = [];
				|		for(var i = 1, j = 0; i < markers.length; i++){
				|			if (isInPoly(layer._latlngs, markers[i]._latlng)){
				|				points[j] = markers[i]._leaflet_id;
				|				j++;
				|			}
				|		
				|		}
				|	var id = """";
				|	if (typeof layer.editing._leaflet_id == ""string""){
				|		id = layer.editing._leaflet_id;
				|	}
				|    PolygonsAndPoints[count] = { 
				|		title: layer.options.label,
				|		id: id,
				|		points: points
				|	};
				|	count++;
				|		
				|	})
				|	return PolygonsAndPoints;
				|}";
		ТекстHTML = ТекстHTML + "
			|
			|	</script>
			|</body>
			|</html>";
	Возврат ТекстHTML;
	
	//} ЭР Сальник К.А.
КонецФункции


&НаСервере
Функция ПолучитьЗоны(КоличествоЗон)
	
	//ЭР Сальник К.А. 13.04.2018 11:34:00 {
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ES_ЗоныГорода.Ссылка,
		|	ES_ЗоныГорода.КодЦвета,
		|	ES_ЗоныГорода.Код,
		|	ES_ЗоныГорода.Наименование
		|ПОМЕСТИТЬ вт
		|ИЗ
		|	Справочник.ES_ЗоныГорода КАК ES_ЗоныГорода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ES_ЗоныГородаСписокКоординат.Долгота,
		|	ES_ЗоныГородаСписокКоординат.Широта,
		|	вт.Ссылка КАК Ссылка,
		|	вт.КодЦвета КАК КодЦвета,
		|	вт.Код КАК Код,
		|	вт.Наименование КАК Наименование
		|ИЗ
		|	вт КАК вт
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ES_ЗоныГорода.СписокКоординат КАК ES_ЗоныГородаСписокКоординат
		|		ПО вт.Ссылка = ES_ЗоныГородаСписокКоординат.Ссылка
		|ИТОГИ
		|	МАКСИМУМ(КодЦвета),
		|	МАКСИМУМ(Код),
		|	МАКСИМУМ(Наименование)
		|ПО
		|	Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаЗона = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТекстHTML = "";
	ТекстHTML = ТекстHTML + Символы.ПС + "var polygons = [];";
	
	НомерЗоны = 1;
	Пока ВыборкаЗона.Следующий() Цикл
		КодЦвета =  ВыборкаЗона.КодЦвета;
		Наименование = ВыборкаЗона.Наименование;
		Если КодЦвета = "" Тогда
			КодЦвета = "#40E0D0";
		КонецЕсли;
		Координаты = ВыборкаЗона.Выбрать();
		ТекстHTML = ТекстHTML + Символы.ПС + "var container = $('<div />');
				|	container.on('click', '#1', function() { var button = document.getElementById(1); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#2', function() { var button = document.getElementById(2); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#3', function() { var button = document.getElementById(3); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#4', function() { var button = document.getElementById(4); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#5', function() { var button = document.getElementById(5); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#6', function() { var button = document.getElementById(6); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#7', function() { var button = document.getElementById(7); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#8', function() { var button = document.getElementById(8); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#9', function() { var button = document.getElementById(9); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#10', function() { var button = document.getElementById(10); bColor = button.style.background.replace(/['""]/g, ''); polygons[" + НомерЗоны+ "].setStyle({fillColor: bColor, color: 'saturate(' + bColor + ', 50%)'}); saveToEdit(polygons[" + НомерЗоны+ "]); });
				|	container.on('click', '#200', function() { var title = document.getElementById(100).value; if (title) { document.getElementById(300).innerHTML = title; document.getElementById(100).value = """"; polygons[" + НомерЗоны+ "].setStyle({label: title}); saveToEdit(polygons[" + НомерЗоны+ "]); } });
				|	container.html(""<h3 id = 300>" + Наименование + "</h3>"" + ""<p>Наименование: <input type = \""text\"" id = 100 value = \""\""><button id = 200>OK</button></p>"" +
				|	""<button id = 1 style = \""background: #9400D3; width: 25; height: 25\"";></button><button id = 2 style = \""background: #FF8C00; width: 25; height: 25\"";></button>"" +  
				|	""<button id = 3 style = \""background: blue; width: 25; height: 25\"";></button><button id = 4 style = \""background: aqua; width: 25; height: 25\"";></button>"" +
				|	""<button id = 5 style = \""background: lime; width: 25; height: 25\"";></button><button id = 6 style = \""background: yellow; width: 25; height: 25\"";></button>"" +
				|	""<button id = 7 style = \""background: red; width: 25; height: 25\"";></button><button id = 8 style = \""background: #A9A9A9; width: 25; height: 25\"";></button>""+
				|	""<button id = 9 style = \""background: #FF1493; width: 25; height: 25\"";></button><button id = 10 style = \""background: green; width: 25; height: 25\"";></button>"");";
		
		ТекстHTML = ТекстHTML + Символы.ПС + "polygons[" + НомерЗоны + "] = L.polygon([";
		Пока Координаты.Следующий() Цикл			 
			ТекстHTML = ТекстHTML + Символы.ПС + "[" + СтрЗаменить(Координаты.Долгота, ",", ".") + ", " + СтрЗаменить(Координаты.Широта, ",", ".") + "],"; 
		КонецЦикла;
		ТекстHTML = Лев(ТекстHTML, Число(СтрДлина(ТекстHTML)) - 1);
		ТекстHTML = ТекстHTML + Символы.ПС + "], {color: 'saturate(" + КодЦвета + ", 50%)', fillColor: '" + КодЦвета + "', fillOpacity: 0.3, label: '" + Наименование + "'}).bindPopup(container[0], { maxWidth : 300 }).addTo(editableLayers);";
		ТекстHTML = ТекстHTML + Символы.ПС + "polygons[" + НомерЗоны + "].editing._leaflet_id = '" + ВыборкаЗона.Код + "';";
		НомерЗоны = НомерЗоны + 1;
	КонецЦикла;
	КоличествоЗон = НомерЗоны -1; 
	Возврат ТекстHTML;
	//} ЭР Сальник К.А.
КонецФункции

&НаСервере
Функция ДобавитьЗаказы(Объект)
	
	//ЭР Сальник К.А. 13.04.2018 11:34:00 {
	ТаблицаЗаказов = СформироватьТаблицуЗаказов(Объект);
	ТекстHTML = "";
	Для Каждого Строка Из ТаблицаЗаказов Цикл
		ТекстHTML = ТекстHTML  + Символы.ПС + "var container = $('<div />');";
		ТекстHTML = ТекстHTML  + Символы.ПС + "container.on('click', '#" + Строка.НомерЗаказа + "', function() { var button = document.getElementById(" + Строка.НомерЗаказа + "); if (button.style.background == ""red"") { button.style.background = 'green'; order = '" + Строка.НомерЗаказа + "'; label = true; markers[" + Строка.НомерЗаказа +"].setIcon(createIcon(""green"", markers[" + Строка.НомерЗаказа +"].options.alt)); markers[" + Строка.НомерЗаказа + "]._icon.id = ""green""; } else { button.style.background = 'red'; order = '" + Строка.НомерЗаказа + "'; label = false; markers[" + Строка.НомерЗаказа +"].setIcon(createIcon(""red"", markers[" + Строка.НомерЗаказа +"].options.alt)); markers[" + Строка.НомерЗаказа + "]._icon.id = ""red""; }});";
		ТекстHTML = ТекстHTML  + Символы.ПС + "container.html(""<strong>" + Строка.НомерЗаказа + ", " + ЛЕВ(Формат(Строка.ВремяДоставкиС, "ДЛФ=T"), СтрДлина(Формат(Строка.ВремяДоставкиС, "ДЛФ=T"))-3) + " - " + ЛЕВ(Формат(Строка.ВремяДоставкиПо, "ДЛФ=T"), СтрДлина(Формат(Строка.ВремяДоставкиПо, "ДЛФ=T")) - 3);
		ТекстHTML = ТекстHTML + "</strong><br />";
		
		Если Строка.Отметка Тогда 
			Цвет = "\""background: green\""";
		Иначе
			Цвет = "\""background: red\""";
		КонецЕсли;

		ТекстHTML = ТекстHTML + "<button id = " + Строка.НомерЗаказа + " style = " + Цвет + ";>Отметить</button><br />";
		ТекстHTML = ТекстHTML + "Накладная: " + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка.Накладная, истина,истина) + "<br />";
		ТекстHTML = ТекстHTML + "<strong>Заказ</strong><br />";
		ТекстHTML = ТекстHTML + "Статус: " + Строка.Статус + "<br />";
		ТекстHTML = ТекстHTML + "Адрес: " + УбратьнепечатаемыеСимволыВКарте(Строка.АдресДоставки) + "<br />";
		ТекстHTML = ТекстHTML + "Время доставки: " + ЛЕВ(Формат(Строка.ВремяДоставкиС, "ДЛФ=T"), СтрДлина(Формат(Строка.ВремяДоставкиС, "ДЛФ=T")) - 3) + " - " + ЛЕВ(Формат(Строка.ВремяДоставкиПо, "ДЛФ=T"),СтрДлина(Формат(Строка.ВремяДоставкиС, "ДЛФ=T")) - 3) + "<br />";
		ТекстHTML = ТекстHTML + "Заказчик: " + Строка.Заказчик + "<br />";
		ТекстHTML = ТекстHTML + "Получатель: " + Строка.Получатель + "<br />";
		ТекстHTML = ТекстHTML + "Примечание: " +  УбратьнепечатаемыеСимволыВКарте(СтрЗаменить(Строка.Комментарий, """", "\""")) + "<br />";
		ТекстHTML = ТекстHTML + "Вес: " + Строка.Вес + "<br />";
		ТекстHTML = ТекстHTML + "Объем: " + Строка.Объем + """);";
		
		Если Строка.Отметка Тогда 
			Иконка = "green";
		Иначе
			Иконка = "red";
		КонецЕсли;
		Надпись = Строка(Строка.НомерЗаказа) + ", " + ЛЕВ(Формат(Строка.ВремяДоставкиС, "ДЛФ=T"), СтрДлина(Формат(Строка.ВремяДоставкиС, "ДЛФ=T"))-3) + " - " + ЛЕВ(Формат(Строка.ВремяДоставкиПо, "ДЛФ=T"), СтрДлина(Формат(Строка.ВремяДоставкиПо, "ДЛФ=T")) - 3);
 		ТекстHTML = ТекстHTML + Символы.ПС + "markers[" + Строка.НомерЗаказа + "] = L.marker([" + СтрЗаменить(Строка.АдресДолгота, ",", ".") + ", " + СтрЗаменить(Строка.АдресШирота, ",", ".") + "], {icon: createIcon(""" + Иконка + """, """ + Надпись + """), alt: '" + Надпись + "'});";
		ТекстHTML = ТекстHTML + Символы.ПС + "markers[" + Строка.НомерЗаказа + "].addTo(map).bindPopup(container[0], { maxWidth : 300 });";
		ТекстHTML = ТекстHTML + Символы.ПС + "markers[" + Строка.НомерЗаказа + "]._leaflet_id = """ + Строка.ИД + """; ";
		ТекстHTML = ТекстHTML + Символы.ПС + "markers[" + Строка.НомерЗаказа + "]._icon.id = """ + Иконка + """; ";
	КонецЦикла;
	Возврат ТекстHTML;
	
	// } ЭР Сальник К.А.
КонецФункции

&НаСервере 
Функция СформироватьТаблицуЗаказов(Объект)
	
	//ЭР Сальник К.А. 13.04.2018 11:35:00 {
	
	МассивЗаказов = Новый Массив;
	
	Для Каждого Строка ИЗ Объект.Заказы Цикл 
		
		СтруктураВМассив = Новый Структура;
		СтруктураВМассив.Вставить("НомерЗаказа" , Строка.НомерСтроки);
		СтруктураВМассив.Вставить("Отметка" , Строка.Отметка);
		СтруктураВМассив.Вставить("Накладная" , Строка.НомерНакладной);
		СтруктураВМассив.Вставить("Статус" , Строка.СтатусДокумента);
		СтруктураВМассив.Вставить("АдресДоставки" , Строка.АдресДоставки);
		СтруктураВМассив.Вставить("АдресШирота" , Строка.АдресДоставкиШирота);
		СтруктураВМассив.Вставить("АдресДолгота" , Строка.АдресДоставкиДолгота);
		СтруктураВМассив.Вставить("ВремяДоставкиС" , Строка.ВремяДоставкиС);
		СтруктураВМассив.Вставить("ВремяДоставкиПо" , Строка.ВремяДоставкиПо);
		СтруктураВМассив.Вставить("Заказчик" , Строка.Заказчик);
		СтруктураВМассив.Вставить("Получатель" , Строка.Получатель);
		СтруктураВМассив.Вставить("Комментарий" , Строка.Комментарий);
		СтруктураВМассив.Вставить("Вес" , Строка.ОбщийВес);
		СтруктураВМассив.Вставить("Объем" , Строка.ОбщийОбъем);
		СтруктураВМассив.Вставить("ИД" , Строка.ДокументДоставки.УникальныйИдентификатор());
		
		МассивЗаказов.Добавить(СтруктураВМассив);
		
	КонецЦикла;  
	
	Возврат МассивЗаказов;
	//} ЭР Сальник К.А.
КонецФункции

&НаСервере 
Функция СформироватьТаблицуПланов(Объект)
	
	//ЭР Сальник К.А. 13.04.2018 11:35:00 {
	МассивПланов = Новый Массив;
	
	Для Каждого Строка ИЗ Объект.СписокАдресовНаКарте Цикл 
		
		СтруктураВМассив = Новый Структура;
		СтруктураВМассив.Вставить("НомерПлана" , Строка.НомерПлана);
		СтруктураВМассив.Вставить("НомерЗаказа" , Строка.НомерСтроки);
		СтруктураВМассив.Вставить("Накладная" , Строка.НомерНакладной);
		СтруктураВМассив.Вставить("Адрес" , Строка.АдресТекстом);
		СтруктураВМассив.Вставить("АдресШирота" , Строка.АдресШирота);
		СтруктураВМассив.Вставить("АдресДолгота" , Строка.АдресДолгота);
		СтруктураВМассив.Вставить("Время" , Строка.ИнтервалВремени);
		СтруктураВМассив.Вставить("ВидДоставки" , Строка.ВидДоставки);
		СтруктураВМассив.Вставить("Комментарий" , Строка.КраткоеОписание);
		СтруктураВМассив.Вставить("ИД" , Строка.Код1С);
		
		МассивПланов.Добавить(СтруктураВМассив);
		
	КонецЦикла;  
	
	Возврат МассивПланов;
	//} ЭР Сальник К.А.
КонецФункции


&НаСервере
Функция ДобавитьПланы(Объект)
	
	//ЭР Сальник К.А. 13.04.2018 11:35:00 {
	ТаблицаПланов = СформироватьТаблицуПланов(Объект);
	ТекстHTML = "";
	Для Каждого Строка Из ТаблицаПланов Цикл
		ТекстHTML = ТекстHTML  + Символы.ПС + "var container = $('<div />');";
		ТекстHTML = ТекстHTML  + Символы.ПС + "container.html(""<strong>" + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка.НомерПлана, истина,истина) + ", " + Строка.НомерЗаказа + ", " + Строка.Время;
		ТекстHTML = ТекстHTML + "</strong><br />";
		ТекстHTML = ТекстHTML + "Накладная: " + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка.Накладная, истина,истина) + "<br />";
		ТекстHTML = ТекстHTML + "<strong>Заказ</strong><br />";
		ТекстHTML = ТекстHTML + "Адрес: " + УбратьнепечатаемыеСимволыВКарте(Строка.Адрес) + "<br />";
		ТекстHTML = ТекстHTML + "Время доставки: " + ЛЕВ(Формат(Строка.Время, "ДЛФ=T"), СтрДлина(Формат(Строка.Время, "ДЛФ=T")) - 3) + "<br />";
		ТекстHTML = ТекстHTML + "Примечание: " +  УбратьнепечатаемыеСимволыВКарте(СтрЗаменить(Строка.Комментарий, """", "\""")) + "<br />"  + """);";		
		Иконка = "blue";
		
		Надпись = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка(Строка.НомерПлана), истина,истина) + ", " + Строка(Строка.НомерЗаказа) + ", " + Строка.Время;
		ТекстHTML = ТекстHTML + Символы.ПС + "plans[" + Строка.НомерЗаказа + "] = L.marker([" + СтрЗаменить(Строка.АдресДолгота, ",", ".") + ", " + СтрЗаменить(Строка.АдресШирота, ",", ".") + "], {icon: createIcon(""" + Иконка + """, """ + Надпись + """), alt: '" + Надпись + "'});";
		ТекстHTML = ТекстHTML + Символы.ПС + "plans[" + Строка.НомерЗаказа + "].addTo(map).bindPopup(container[0], { maxWidth : 300 });";
		ТекстHTML = ТекстHTML + Символы.ПС + "plans[" + Строка.НомерЗаказа + "]._leaflet_id = """ + Строка.ИД + """; ";	
	КонецЦикла;
	Возврат ТекстHTML;

	//} ЭР Сальник К.А.
КонецФункции



&НаСервере
Функция УбратьнепечатаемыеСимволыВКарте(Строка) Экспорт
	
	НоваяСтрока = СтрЗаменить(Строка,"¶","");
	НоваяСтрока = СтрЗаменить (НоваяСтрока, Символ(13), "");
	НоваяСтрока = СтрЗаменить (НоваяСтрока, Символы.ПС, "");
	НоваяСтрока = СтрЗаменить(НоваяСтрока,"'","");
	НоваяСтрока = СтрЗаменить(НоваяСтрока, Символ(11), "");
	
	Возврат НоваяСтрока;
	
КонецФункции


&НаСервере
Процедура УдалитьЗонуНаСервере(Код) Экспорт 
	
	//ЭР Сальник К.А. 13.04.2018 11:35:00 {
	Зона = Справочники.ES_ЗоныГорода.НайтиПоКоду(Код).ПолучитьОбъект();
	Зона.Удалить();	
	//} ЭР Сальник К.А.
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗонуНаСервере(Наименование, Цвет, Код, Координаты) Экспорт
	
	//ЭР Сальник К.А. 13.04.2018 11:36:00 {
	Зона = Справочники.ES_ЗоныГорода.НайтиПоКоду(Код).ПолучитьОбъект();
	Зона.КодЦвета = Цвет;
	Зона.Наименование = Наименование;
	Зона.СписокКоординат.Очистить();
	Для Каждого Строка Из Координаты Цикл
		ЗаполнитьЗначенияСвойств(Зона.СписокКоординат.Добавить(), Строка);
	КонецЦикла;
	
	Зона.Записать();
	//} ЭР Сальник К.А.
	
КонецПроцедуры


&НаСервере
Процедура CоздатьЗонуНаСервере(Наименование, Цвет, Код, Координаты)   Экспорт
	
	//ЭР Сальник К.А. 13.04.2018 11:36:00 {
	Зона = Справочники.ES_ЗоныГорода.СоздатьЭлемент();
	Зона.Наименование = Наименование;
	Зона.КодЦвета = Цвет;
	Для Каждого Строка Из Координаты Цикл
		ЗаполнитьЗначенияСвойств(Зона.СписокКоординат.Добавить(), Строка);
	КонецЦикла;
	
	Зона.Записать();
	//} ЭР Сальник К.А.
КонецПроцедуры
	
	
&НаСервере	
Функция СоздатьПланыДоставкиПоЗонам(МассивЗон, Ответственный)  Экспорт    
	
	//ЭР Сальник К.А. 13.04.2018 11:36:00 {
	ТаблицаЗон = Новый ТаблицаЗначений;
	
	ТаблицаЗон.Колонки.Добавить("ЗонаСсылка");
	ТаблицаЗон.Колонки.Добавить("КурьерСсылка");
	ТаблицаЗон.Колонки.Добавить("ДокументыСсылки");
	
	Для Каждого Зона Из МассивЗон Цикл
		КодЗоны = Зона.Код;
		Строка = ТаблицаЗон.Добавить();
		ЗонаСсылка = Справочники.ES_ЗоныГорода.НайтиПоКоду(КодЗоны);
		Строка.ЗонаСсылка = ЗонаСсылка;
		Строка.КурьерСсылка = ЗонаСсылка.Курьер;
		ДокументыСсылки = Новый Массив;
		Для Каждого Заказ Из Зона.Заказы Цикл
			Документ = Документы.ЗаказПокупателя.ПолучитьСсылку(Новый УникальныйИдентификатор(Заказ));
			Если Документ.ПолучитьОбъект() = Неопределено Тогда
				Документ = Документы.ES_ЗаборГруза.ПолучитьСсылку(Новый УникальныйИдентификатор(Заказ));
				ДокументыСсылки.Добавить(Документ);
			Иначе
				Если НЕ Документ.ES_ВидДоставки = Перечисления.ES_ВидыДоставки.Самовывоз Тогда
					ДокументыСсылки.Добавить(Документ);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Строка.ДокументыСсылки = ДокументыСсылки;
	КонецЦикла;
	
	
	
	МассивСообщений = Новый Массив;
		
	Для каждого Зона Из ТаблицаЗон Цикл
		ДокументыДоставки = Зона.ДокументыСсылки;		
		Если ДокументыДоставки.Количество() = 0 Тогда
			Продолжить;			
		КонецЕсли;
		 
		КурьерЗоны = 	Зона.КурьерСсылка;	
		НовыйДокумент = Документы.ES_ПланДоставки.СоздатьДокумент();
		НовыйДокумент.Дата 			= ТекущаяДатаСеанса();
		НовыйДокумент.Автор 		= Пользователи.ТекущийПользователь();
		НовыйДокумент.Ответственный = Ответственный;
		НовыйДокумент.Курьер 		= КурьерЗоны;
		
		ES_ОбщегоНазначения.ПолучитьДанныеПоЗаказамДляЗаполненияПланаДоставки(Тип("ДокументСсылка.ES_ПланДоставки"), НовыйДокумент, ДокументыДоставки);
		
		РежимЗаписи = ?(ЗначениеЗаполнено(КурьерЗоны), РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись);
		
		Попытка
			НовыйДокумент.Записать(РежимЗаписи);
			МассивСообщений.Добавить(НовыйДокумент.Ссылка);
		Исключение
		    МассивСообщений.Добавить("Не удалось записать новый План доставки по зоне " + Зона);
		КонецПопытки;
	
	КонецЦикла; 
	
	Возврат МассивСообщений;

	//} ЭР Сальник К.А.	
КонецФункции



Функция ПолучитьКарту(Параметры) 	Экспорт
	
	//ЭР Сальник К.А. 13.04.2018 11:36:00 {
	Долгота = Параметры.Долгота;
	Широта = Параметры.Широта;
	Адрес = Параметры.Адрес;
	Метро = Параметры.Метро;

	
	// формируем основной текст карты
	
	
	ТекстHTML = "<!DOCTYPE html>
	|<html>
	|<head>
	//|	<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	|	<meta http-equiv=""X-UA-Compatible"" content=""IE=5"" />	
	|
	|	<link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.2/leaflet.css"" />
	|
	|	<script src=""https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.2/leaflet.js""></script>
	|
	|	<style>
	|		#map {
	|			width: 100%;
	|			height: 100%;
	|		}
	|		.my-div-icon {
	|       	font-weight: bold;
	|			white-space: nowrap;
	|			font-size: 110%; 
	|		}
	|	</style>
	|
	|</head>
	|<body>
	|	<div id=""map""></div>
	|		<script>
	|       
	|		var lat = """ + СтрЗаменить(Долгота, ",", ".") + """;
	|		var lng = """ + СтрЗаменить(Широта, ",", ".") + """;
	|		var map = L.map('map',{
    |		center: [" + СтрЗаменить(Долгота, ",", ".") + ", " + СтрЗаменить(Широта, ",", ".") + "],
    |		zoom: 15
    |		});
	|
	|		L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    |			attribution: '&copy; <a href=""http://osm.org/copyright"">OpenStreetMap</a> contributors'
    |		}).addTo(map);
	|
	|		function createIcon(address){
	|			if (address){
	|				var myIcon = new L.divIcon({
	|					className: 'my-div-icon',
	|					iconAnchor: [10, 75],
	|					html: '<div><span style = ""background: #F8C6C3; padding: 2px; height: 20px; filter: alpha(opacity=80); ""> Адрес:  <i>" + Адрес + "</i><br> Метро:  <i>" + Метро + "</i></span><br><img src=""https://cdn2.iconfinder.com/data/icons/IconsLandVistaMapMarkersIconsDemo/256/MapMarker_PushPin_Right_Pink.png"" width=""40"" height=""41""></div>'
	|				});
	|				return myIcon;
	|				}else {
	|					var myIcon = new L.divIcon({
	|						className: 'my-div-icon',
	|						iconAnchor: [10, 35],
	|						html: '<div><img src=""https://cdn2.iconfinder.com/data/icons/IconsLandVistaMapMarkersIconsDemo/256/MapMarker_PushPin_Right_Pink.png"" width=""40"" height=""41""></div>'
	|		
	|					});
	|					return myIcon;
	|				}
	|		}
	|
	|		function getCoord(coord){
	|			if (coord == ""lat""){
	|				return lat;
	|			}
	|			else{
	|				if (coord == ""lng""){
	|					return lng;
	|				}
	|			}
	|		}
	|		
	|		";
	ТекстHTML = ТекстHTML + Символы.ПС + "var marker = L.marker([" + СтрЗаменить(Долгота, ",", ".") + ", " + СтрЗаменить(Широта, ",", ".") + "], {icon:  createIcon(true), draggable: true});";
	ТекстHTML = ТекстHTML + Символы.ПС + "marker.addTo(map);";
	ТекстHTML = ТекстHTML + "
	|		marker.on(""dragend"", function(e){
	|			lat = e.target._latlng.lat;
	|			lng = e.target._latlng.lng;
	|			marker.setIcon(createIcon(false));
	|		});
	|
	|	</script>
	|</body>
	|</html>";
		
	Возврат ТекстHTML;
//} ЭР Сальник К.А.
	
КонецФункции	


Функция ПолучитьАдресПоКоординатам(Долгота, Широта)   Экспорт
	
	//ЭР Сальник К.А. 13.04.2018 11:36:00 {
	АдресСервера = "geocode-maps.yandex.ru";
	АдресРесурса = "1.x/?"+ПараметрыСеанса.ES_APIКлючЯндекса+"geocode=" + СтрЗаменить(Строка(Широта), ",", ".") + "," + СтрЗаменить(Строка(Долгота), ",", ".") + "&format=xml&results=1";
	АдресРесурсаМетро = "1.x/?geocode=" + СтрЗаменить(Строка(Широта), ",", ".") + "," + СтрЗаменить(Строка(Долгота), ",", ".") + "&kind=metro&format=xml&results=1";

	
	Попытка
		
		Соединение = Новый HTTPСоединение(АдресСервера,,,,,,Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(),
		Новый СертификатыУдостоверяющихЦентровWindows()
		)
		);
	
		ФайлРезультата = ПолучитьИмяВременногоФайла("xml");		
		Соединение.Получить(АдресРесурса, ФайлРезультата);
		Соединение = Неопределено;		
	Исключение			
	КонецПопытки;
	
	
	СтруктураОтвета = Новый Структура;
	
	СтруктураОтвета.Вставить("Долгота");
	СтруктураОтвета.Вставить("Широта");
	СтруктураОтвета.Вставить("Адрес");
	СтруктураОтвета.Вставить("ЛинияМетро");
	СтруктураОтвета.Вставить("Метро");	
	
	ЧтениеXML   = Новый ЧтениеXML;
 	ЧтениеXML.ОткрытьФайл(ФайлРезультата);
	
	Пока ЧтениеXML.Прочитать() Цикл
		
 		Если ЧтениеXML.Имя = "pos" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = РазбитьСтрокуПоСимволу(ЧтениеXML.Значение, " ");
				СтруктураОтвета.Вставить("Широта", Данные.Л);
				СтруктураОтвета.Вставить("Долгота", Данные.П);
									
			КонецЕсли;
			
		КонецЕсли;
		Если ЧтениеXML.Имя = "AddressLine" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				СтруктураОтвета.Вставить("Адрес", Данные);
									
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
		
 	ЧтениеXML.Закрыть();
	ЧтениеXML = Неопределено;
		
	УдалитьФайлы(ФайлРезультата);
	
	Попытка
		
		Соединение = Новый HTTPСоединение(АдресСервера,,,,,,Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(),
		Новый СертификатыУдостоверяющихЦентровWindows()
		)
		);
	
		ФайлРезультата = ПолучитьИмяВременногоФайла("xml");		
		Соединение.Получить(АдресРесурсаМетро, ФайлРезультата);
		Соединение = Неопределено;		
	Исключение			
	КонецПопытки;
	
	ЧтениеXML   = Новый ЧтениеXML;
 	ЧтениеXML.ОткрытьФайл(ФайлРезультата);
	
	Пока ЧтениеXML.Прочитать() Цикл
		
 		Если ЧтениеXML.Имя = "ThoroughfareName" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				СтруктураОтвета.Вставить("ЛинияМетро", Данные);
									
			КонецЕсли;
			
		КонецЕсли;
		Если ЧтениеXML.Имя = "PremiseName" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				СтруктураОтвета.Вставить("Метро", Данные);
									
			КонецЕсли;
			
		КонецЕсли;

	КонецЦикла;
		
 	ЧтениеXML.Закрыть();
		
	УдалитьФайлы(ФайлРезультата);

	Возврат СтруктураОтвета;	
//} ЭР Сальник К.А.

КонецФункции


Функция РазбитьСтрокуПоСимволу(Текст, Символ)
	
	ПозСимвол = Найти(Текст, Символ);
	Л = Лев(Текст, ПозСимвол - 1);
	П = НРег(Прав(Текст, СтрДлина(Текст) - ПозСимвол));
	
	Возврат Новый Структура("Л,П", Л,П);
	
КонецФункции

	





