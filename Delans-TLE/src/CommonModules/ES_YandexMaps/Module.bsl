////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
//
//
// 



////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Функции работы с картой:
//   - формирование текста
//   - обработка нажатия
// 	 - отметка заказа
//	 - построение маршрута
//   - получение данных (текстовое описание маршрута)
//	 - получения заказов по областям


// Функция формирует и возвращает текст html-ки работы с картой
Функция ПолучитьТекстКарты(СписокЗаказов, СписокОбластей, Параметры, АПИКлюч)                             ЭКСПОРТ
	
	// параметры.Маршрут.НачальнаяТочка
	// параметры.Маршрут.КонечнаяТочка
	// параметры.Маршрут.Пробки......=>
	
	// центр, масштаб, окошки и т.д.
	ТекстКарта = Я_ПолучитьТекстКарты(Параметры);
	
	// формирует JS для вывода списка заказов, начальных и конечных точек
	ТекстСписокЗаказов = Я_ПолучитьТекстФормированияТочекЗаказов(СписокЗаказов, Параметры);
	
	// 
	//ТекстМашруты = Я_ПолучитьТекстФормированияМаршутов(Параметры);
	
	Если Параметры.ОтобразитьКурьеров Тогда
		ТекстСписокКурьеров = ES_ОбщегоНазначения.Я_ПолучитьТекстФормированияТочекМестонахожденияКурьеров();
	Иначе
		ТекстСписокКурьеров = "";
	КонецЕсли;
	
	//
	ТекстОбласти = Я_ПолучитьТекстФормированияОбластей(СписокОбластей, Параметры);
	
	ТекстЭлементРазмещения = Я_ПолучитьТекстЭлементРазмещения(Параметры);
	
	// вставляем сформированные значения в общий шаблон
	Текст = Я_ПолучитьHtmlШаблонКарты(ТекстЭлементРазмещения, ТекстКарта, (ТекстСписокЗаказов + Символы.ПС +ТекстСписокКурьеров), ТекстОбласти, АПИКлюч);
	
	Возврат Текст;
	
КонецФункции

// Основной шаблон Яндекс-карты
Функция Я_ПолучитьHtmlШаблонКарты(ТекстЭлементРазмещения, ТекстКарта, ТекстСписокЗаказов, ТекстОбласти, АПИКлюч="")
		
	html = "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN"">
|<html>
|<head>
//|	<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
|	<meta http-equiv='X-UA-Compatible' content='IE=9' />
|	<title>Примеры. Размещение карты на странице.</title>
|	<style>
|		.my-button-selected {
|			color: #333333;
|			background-color: #e6e6e6;
|			outline: 2px dashed #333;
|			outline: 5px auto -webkit-focus-ring-color;
|			outline-offset: -2px;
|		}

|		.my-button {
|			display: inline-block;
|			padding: 4px 14px;
|			margin-bottom: 0;
|			font-size: 14px;
|			line-height: 20px;
|			color: #333333;
//|			text-align: center;
|			vertical-align: middle;
|			cursor: pointer;
|			background-color: #f5f5f5;
|			border: 1px solid #bbbbbb;
|			border-color: #e6e6e6 #e6e6e6 #bfbfbf;
|			font-family: Arial;
|			position: absolute;
|		}

|		.link {
|			color: #77B0ED;
|			text-decoration: underline;
|			cursor: pointer;
|		}

|		.link-red {
|			color: red;
|			text-decoration: underline;
|			cursor: pointer;
|		}

|		.link-green {
|			color: green;
|			text-decoration: underline;
|			cursor: pointer;
|		}
| 		.link-blue {
|            color: blue;
|            text-decoration: underline;
|            cursor: pointer;
|        }
|	</style>
|	<script src='http://api-maps.yandex.ru/2.0-stable/?"+АПИКлюч+"load=package.full&lang=ru_RU' type='text/javascript'></script>
|	<script type='text/javascript'>
|		var myMap,            
|			placemarksProvider,
|			zonesProvider,
|			routerProvider,
|			myData,
|			myRouteMap = {
|				moveList: '',
|				length: 0,
|				time: 0
|			};
|		
|		ymaps.ready(init);

|		// Инициализация (кэп)
|		function init() {
|			
|			myMap = ya_get_map();       // создаем карту            
|			map_prepare(myMap);         // параметры карты

|			// провайдеры                
|			placemarksProvider = new PlacemarksProvider();                   
|			zonesProvider = new ZonesProvider();                             
|			routerProvider = new RouterProvider(myMap, myRouteMap,
|				function () {
|					document.getElementById(""route_process"").style.display = 'block';
|				},
|				function () {
|					document.getElementById(""route_process"").style.display = 'none';
|				});     // (в конструктор передаются 2 колбэка для отображения и скрытия статуса построяния маршрута)

|			// заполнение данными
|			ya_get_placemarks(placemarksProvider);            
|			ya_build_zones(myMap, placemarksProvider.getPlacemarks());
|			
|			build_clusterer(myMap, placemarksProvider.getPlacemarks()); // задаем параметры кластеризатора (объенинение ближних точек)
|							
|			add_zones_buttons();        // кнопка управления зонами
|		}
|		
|		//***********************************************************************************************************************
|		//
|		// работа с метками
|		//

|		// объект создается конструктором new 
|		function PlacemarksProvider() {

|				// private

|			var items = [];     // список заказов

|				// public

|			// 
|			this.addOrder = function (order) {
|				// создаем элемент локального массива
|				var item = new Order(order, items.length);
|				
|				// добавляем метку на карту
|				var placemark = map_addPlacemark(order.coordinates, order.iconContent, order.balloonBody, order.doc1cFlag, order.hintContent, order.pressHandle, order.linked, item,order.colorSet,order.colorLabel);

|				// стваим ссылку метки катры в объект локального массива                     
|				item.ref = placemark;

|				// добавляем метку в ""локальный массив""
|				items.push(item);

|				item.setBalloonBody();
|			};

|			// функция поиска заказа по индексу
|			this.findOrderByIndex = function (index) {
|				return items[index];
|			}

|			// функция поиска заказа по коду 1с
|			this.findOrderByDoc1cCode = function (code) {
|				var res = null;

|				for (var i = 0; i < items.length; i++) {
|					if (items[i].doc1cCode == code) {
|						res = items[i];
|					}
|				}

|				return res;
|			}

|			// функция получает список всех точек на карте
|			this.getPlacemarks = function () {
|				var res = [];

|				for (var i = 0; i < items.length; i++) {
|					res.push(items[i].ref);
|				}

|				return res;
|			}

|			// проведение заказов (первый аргемент - заказ а не метка!)
|			this.processOrders = function (orders, fireEvent) {
|				// если все отмечены, тогда снимаем отметки у всех
|				// если отмечены не все, тогда отмечаем те, которые не отмечены
|				var buffer = [];
|				for (var i = 0; i < orders.length; i++) {
|					if (!orders[i].doc1cFlag) buffer.push(orders[i]);
|				}
|				var newState = true;
|				// если в буффере нет заказов, тогда все отмечены, нужно снять отметки
|				if (buffer.length == 0) {
|					newState = false;
|					buffer = orders;
|				}
|				var elemValue = '';
|				// проходим по массиву
|				for (var i = 0; i < buffer.length; i++) {
|					buffer[i].setState(newState);
|					// формируем значение элемента со списком кодов документов
|					elemValue += ('' + buffer[i].doc1cCode + '=' + newState);
|					if (i < buffer.length - 1) elemValue += ',';
|				}
|				if (fireEvent) {
|					// set div order value
|					var elem = document.getElementById('order');            // TODO : тут влепить какой-небудь колбэк
|					elem.value = elemValue;
|					var event = document.createEventObject();
|					elem.fireEvent('onclick', event);
|				//	if (event) {
|				//		console.log('event: onClick');
|				//	} else {
|				//		elem.fireEvent('onclick', document.createEventObject());
|				//	}
|				}
|			};

|			//
|			this.processOrderByIndex = function (index) {
|				var order = this.findOrderByIndex(index);
|				this.processOrders([order], true);
|			}

|			//
|			this.getOrders = function () {
|				return items;
|			}

|			return this;
|		}
|		
|		// Объект - Заказ. Создается при помощи конструктора new
|		function Order(order, index) {
|			
|			// private

|			// public 

|				// fields
|			this.doc1cCode = order.doc1cCode;
|			this.doc1cFlag = order.doc1cFlag;
|			this.pressHandle = order.pressHandle;
|			this.routeUse = order.routeUse;
|			this.address = order.address;
|			this.orderInfo = order.orderInfo;
|			this.linked = order.linked;
|			this.index = index;
|			this.ref = null;              // ссылка на элемент карты (на Placemark)

|				// methods

|			// функция нажатия на метку
|			Order.prototype.onClick = function () {
|				placemarksProvider.processOrders([this], true);
|			};

|			// функция сметы текста описания метки
|			Order.prototype.setBalloonBody = function () {
|				var hrefColor = (this.doc1cFlag ? (this.linked ? 'link-blue' : 'link-green') : (this.linked ? 'link-green' : 'link-red'));

|				var text = this.pressHandle ?
|						'<div><div class=""' + hrefColor + '"" onclick=""placemarksProvider.processOrderByIndex(' + this.index + ')"">' + (this.doc1cFlag ? 'Снять отметку' : 'Отметить заказ') + '</div></div><br/>' +
|						'<div><div><i>' + this.orderInfo + '</i></div></div>' :
|						'<div><div><i>' + this.orderInfo + '</i></div></div><br/>'
|				'<div><div><i>Заказ в плане</i></div></div>';
|				this.ref.properties.set('balloonContentBody', text);
|			};
//ЕФСОЛ Несторук 12.08.2016 +
|			// функция смены статуса метки
|			Order.prototype.setState = function (state) {
|				var preset = 'twirl#darkgreenStretchyIcon';
|				if (this.linked) {
|					preset = state ? 'twirl#darkgreenStretchyIcon' : 'twirl#blueStretchyIcon';
|				} else {
|					preset = state ? 'twirl#darkgreenStretchyIcon' : 'twirl#redStretchyIcon';
|				}

|				this.ref.options.set('preset', preset);
|				this.doc1cFlag = state;
|				this.setBalloonBody();
|			};
//|			// функция смены статуса метки
//|			Order.prototype.setState = function (state) {
//|				var preset = 'twirl#darkgreenIcon';
//|				if (this.linked) {
//|					preset = state ? 'twirl#darkgreenIcon' : 'twirl#blueIcon';
//|				} else {
//|					preset = state ? 'twirl#darkgreenIcon' : 'twirl#redIcon';
//|				}

//|				this.ref.options.set('preset', preset);
//|				this.doc1cFlag = state;
//|				this.setBalloonBody();
//|			};
//ЕФСОЛ Несторук 12.08.2016 -
|			// функция закрытия описания
|			Order.prototype.closeBalloon = function () {
|				this.ref.balloon.close();
|			};

|			return this;        // не обязательно, но пусть будет
|		}

|		// добавление метку на марту яндекса. возвращает ссылку на объект метки
|		function map_addPlacemark(coordinates, iconContent, balloonBody, doc1cFlag, hintContent, pressHandle, linked, objRef, colorSet, colorLabel) {
|			var placemark = new ymaps.Placemark(
|				coordinates,
|				{
|						// main properties
|					balloonContentHeader: iconContent,
|					balloonContentBody: balloonBody,
|					hintContent: iconContent,
|					iconContent: iconContent,                    
|						// custom properties
|					objRef: objRef          // ссылка на объект в массиве (для быстрейшего поиска объекта)
|				}, {
|					preset: colorSet ? colorLabel : (linked ? (pressHandle ? (doc1cFlag ? 'twirl#darkgreenIcon' : 'twirl#blueIcon') : 'twirl#greyIcon') : (pressHandle ? (doc1cFlag ? 'twirl#darkgreenIcon' : 'twirl#redIcon') : 'twirl#greyIcon'))
|				});

|			placemark.events.add('click', function (e) {                
|				//if (pressHandle) objRef.onClick(objRef);     // вызываем событие отметки заказа (с передачей события 1с-ке)
|				//e.preventDefault();
|			});

|			return placemark;
|		}
|		
|		//***********************************************************************************************************************
|		//
|		// работа с зонами
|		//

|		// объект создается конструктором new 
|		function ZonesProvider() {
|			
|				// private 

|			var maxIndex = 0;

|				// public 

|			this.zones = [];

|			this.getMaxIndex = function () {
|				return maxIndex;
|			}

|			this.addZone = function (zoneInfo) {                
|				var zone = new Zone(zoneInfo, maxIndex++);
|				var polygon = new ymaps.Polygon([zone.coordinates, []],
|					{
|						hintContent: zone.hintContent,
|						objRef: zone               // ссылка на объект в массиве                            
|					}, {
|						fillColor: zone.fillColor,
|						interactivityModel: 'default#transparent',
|						strokeWidth: 1,
|						opacity: 0.5,
|						draggable: false
|					});
|				zone.ref = polygon;
|				myMap.geoObjects.add(polygon);
|				// ~ polygone

|				zone.update_balloon();

|				this.zones.push(zone);

|				return zone;
|			};

|			// 
|			this.deselectZones = function () {
|				for (var i = 0; i < this.zones.length; i++) {
|					if (this.zones[i].ref.editor.state.get('editing')) {
|						this.zones[i].ref.editor.stopEditing();
|					}
|				}
|			}

|			//
|			this.removeById = function (id) {
|				var index = this.findIndexById(id);
|				if (!confirm('Удалить выбранную область?')) return;
|				myMap.geoObjects.remove(this.zones[index].ref);
|				this.zones.splice(index, 1);
|			};

|			//
|			this.findIndexById = function (id) {
|				var res = 0;
|				for (var i = 0; i < this.zones.length; i++) {
|					if (this.zones[i].id == id) {
|						res = i;
|						i = this.zones.length;
|					}
|				}
|				return res;
|			};

|			//
|			this.findById = function (id) {
|				return this.zones[this.findIndexById(id)];
|			}

|			//
|			this.getZoneByIndex = function (index) {
|				return this.zones[index];
|			}

|			//            

|			return this;
|		}

|		// объект создается конструктором new  
|		function Zone(zoneInfo, index) {

|				// private  
|			
|				// public 

|			this.ref = null;
|			this.id = 'id_' + index;
|			this.name = zoneInfo.zoneName,
|			this.coordinates = zoneInfo.coordinates,
|			this.fillColor = zoneInfo.fillColor,
|			this.hintContent = zoneInfo.hintContent,
|			this.code1c = zoneInfo.zoneCode1c,

|			Zone.prototype.startDrawing = function () {
|				this.ref.editor.startDrawing();
|			}

|			Zone.prototype.edit = function () {
|				this.ref.editor.startEditing();
|				this.ref.balloon.close();
|			};

|			Zone.prototype.set_color = function (color) {
|				this.ref.options.set('fillColor', color);
				//EFSOL_Сальник К.А. 2019-04-18 {+
|				this.fillColor = color;
				//EFSOL_Сальник К.А.  -}
|				this.ref.balloon.close();
|			};

|			//
|			Zone.prototype.name_edit_begin = function () {
|				// прячем надпись
|				document.getElementById('zone_name_edit_label_' + this.id).style.display = 'none';
|				// заполняем наименование
|				document.getElementById('zone_name_edit_field_' + this.id).value = this.name;
|				// отображаем панель редактирования
|				document.getElementById('zone_name_edit_panel_' + this.id).style.display = 'block';
|			};

|			//
|			Zone.prototype.name_edit_ok = function () {
|				// установка нового значения наименования
|				var zoneNewName = document.getElementById('zone_name_edit_field_' + this.id).value;
|				this.name = zoneNewName;
|				document.getElementById('zone_name_edit_header_' + this.id).innerHTML = zoneNewName;
|				this.update_balloon();
|				// прячем панель редактирования
|				document.getElementById('zone_name_edit_panel_' + this.id).style.display = 'none';
|				// отображаем надпись редактирования
|				document.getElementById('zone_name_edit_label_' + this.id).style.display = 'block';
|			};

|			//
|			Zone.prototype.name_edit_cancel = function () {
|				// прячем панель редактирования
|				document.getElementById('zone_name_edit_panel_' + this.id).style.display = 'none';
|				// отображаем надпись редактирования
|				document.getElementById('zone_name_edit_label_' + this.id).style.display = 'block';
|			};

|			//
|			Zone.prototype.update_balloon = function () {
|				var text = this.prepareBalloonContent();
|				this.ref.properties.set('balloonContent', text);
|			};

|			//
|			Zone.prototype.process_orders = function () {
|				this.ref.balloon.close();

|				// получаем список заказов в зоне
|				var ordersInZone = ymaps.geoQuery(placemarksProvider.getPlacemarks()).searchInside(this.ref);
|				// по каждому вызываем processOrder(order)
|				var ordersArray = new Array();
|				for (var j = 0; j < ordersInZone.getLength() ; j++) {
|					var order = ordersInZone.get(j).properties.get('objRef');
|					if (!order.pressHandle) continue;
|					ordersArray.push(order);
|				};

|				placemarksProvider.processOrders(ordersArray, true);
|			}
|			
|			//
|			Zone.prototype.prepareBalloonContent = function () {
|				var res = '';

|				// заголовок
|				res += '<div><h4 id=""zone_name_edit_header_' + this.id + '"">' + this.name + '</h4></div>';
|				// переименование                    
|				res += '<div class=""link"" id=""zone_name_edit_label_' + this.id + '"" onclick=zonesProvider.findById(""' + this.id + '"").name_edit_begin()>Переименовать</div>';
|				res += '<div id=""zone_name_edit_panel_' + this.id + '"" style=""display:none"">' +
|							'<input type=""text"" id=""zone_name_edit_field_' + this.id + '"" value=' + this.name + ' size=10/>' +
|							'<input type=""button"" value=""OK"" onclick=zonesProvider.findById(""' + this.id + '"").name_edit_ok() />' +
|							'<input type=""button"" value=""Отмена"" onclick=zonesProvider.findById(""' + this.id + '"").name_edit_cancel() />' +
|						'</div>';
|				// кнопка удаления
|				res += '<div class=""link""><p onclick=""zonesProvider.removeById(\'' + (this.id) + '\')"">Удалить</p></div>';
|				// кнопка редактирования
|				res += '<div class=""link""><p onclick=""zonesProvider.findById(\'' + (this.id) + '\').edit()"">Редактировать</p></div>';
|				// кнопка выгрузки всех
|				res += '<div class=""link""><p onclick=""zonesProvider.findById(\'' + (this.id) + '\').process_orders()"">Отметить заказы</p></div>';
|				res += '<hr/ >';
|				// выбор цветов
|				var colorsTd = '';
|				var colorsList = get_colors();
|				for (var i = 0; i < colorsList.length; i++) {
|					colorsTd += '<td bgcolor=""' + colorsList[i] + '"" width=""16px"" height=""16px"" onclick=""zonesProvider.findById(\'' + this.id + '\').set_color(\'' + colorsList[i] + '\')""></td>';
|				}
|				res += '<div><table style=""border-spacing: 10px;""><tr>' + colorsTd + '</tr></table></div>';
|				return res;
|			}

|			return this;

|		}

|		//***********************************************************************************************************************
|		//
|		// работа с построителем мартшура (объект создается при помощи конструктора new )
|		//

|		// объект создается конструктором new 
|		function RouterProvider(map, info, onBeginBuild, onFinishBuild) {

|				// private
|	
|			var routePoints,             // список точек марштура, которые генерит построитель маршрута
|				isBuilt = false,         // признак того, что марштур построен   
|				routeOnMap,              // объект марштура   
|				beginPoint,
|				endPoint,
|				avoidTrafficJams,
|				orders; 
|				
|			// функция очистки предыдущих маршрутов
|			function clearRoutes() {
|				var i;

|				map.geoObjects.remove(routeOnMap);

|				for (i = 0; i < routePoints.getLength() ; i++) {
|					map.geoObjects.remove(routePoints.get(i));                    
|				}

|				routePoints.removeAll();
|			};

|			// функция формирует массив точек для построения маршрута (включая начальную и конечную )
|			function getPointsForRoute() {
|				var points = [];

|				points.addPoint = function (coordinates) {
|					this.push({
|						type: 'wayPoint',
|						point: coordinates
|					});
|				}

|				// заносим начальную и конечную точки в общий список точек                
|				if (beginPoint) points.addPoint(beginPoint);

|				for (var i = 0; i < orders.length; i++) {
|					if (orders[i].routeUse) {
|						points.addPoint(orders[i].ref.geometry.getCoordinates());                        
|					}
|				}

|				if (endPoint) points.addPoint(endPoint);

|				return points;
|			}

|			// функция строит информацию о маршруте
|			function getRouteInfo() {

|				// сохраняем карту маршрута                			    
|				var moveList = '',
|					way,
|					segments,
|					length = 0,
|					time = 0,
|					i, j,
|					totalLength,
|					routePathes,
|					street,
|					addressPoints = [];
|				
|				routePathes = routeOnMap.getPaths();
|				totalLength = routeOnMap.getPaths().getLength();

|				if (beginPoint) {
|					addressPoints.push({
|						address: beginPoint.address || 'начальная точка'
|					});
|				}

|				for (i = 0; i < orders.length; i++) addressPoints.push({ address: orders[i].address });

|				if (endPoint) {
|					addressPoints.push({
|						address: endPoint.address || 'конечная точка'
|					});
|				}

|				moveList += (beginPoint ? '<<Начало маршрута (' + (beginPoint.address || 'начальная точка') + ')>>' : '[[Точка: ' + addressPoints[0].address + ' ]]') + '\n';

|				// Получаем массив путей.
|				for (i = 0; i < totalLength; i++) {

|					way = routePathes.get(i);
|					segments = way.getSegments();
|					for (j = 0; j < segments.length; j++) {
|						street = segments[j].getStreet();
|						moveList += ('Едем ' + segments[j].getHumanAction() + (street ? ' на ' + street : '') + ', проезжаем ' + segments[j].getLength() + ' м.,');
|						moveList += '; '
|					}

|					length += way.getLength();
|					time += (avoidTrafficJams ? way.getJamsTime() : way.getTime());

|					if (i < totalLength - 1) {
|						moveList += '\n[[Точка: ' + addressPoints[i + 1].address + ']]\n';
|					}
|					else {
|						moveList += '\n';
|					}
|				}
|				
|				moveList += (endPoint ? '<<Конец маршрута (' + (endPoint.address || 'конечная точка') + ')>>' : '[[Точка: ' + addressPoints[addressPoints.length - 1].address + ' ]]') + '\n';

|				return {
|					moveList: moveList,
|					length: length,
|					time: time
|				};
|			}

|			// функция отображения начальной и конечной точек
|			function showBeginEndPoints() {

|				// устанавливаем параметры начальной точки
|				if (beginPoint) {
|					routePoints.get(0).options.set('visible', true);
|					routePoints.get(0).properties.set('hintContent', 'Точка отправления');
|					routePoints.get(0).properties.set('iconContent', 'A');
|					routePoints.get(0).options.set('preset', 'twirl#yellowIcon');
|				}

|				// устанавливаем параметры конечной точки точки
|				if (endPoint) {
|					routePoints.get(routePoints.getLength() - 1).options.set('visible', true);
|					routePoints.get(routePoints.getLength() - 1).properties.set('hintContent', 'Точка прибытия');
|					routePoints.get(routePoints.getLength() - 1).properties.set('iconContent', 'Б');
|					routePoints.get(routePoints.getLength() - 1).options.set('preset', 'twirl#yellowIcon');
|				}
|			}

|			//
|			function getPointAddress(point) {
|				if (point) {
|					ymaps.geocode(point).then(
|						function (res) {
|							point.address = res.geoObjects.get(0).properties.get('name');
|						});
|				}
|			}

|				// public
|		
|			// функция построения марштура
|			this.buildRoutes = function (_orders, _beginPoint, _endPoint, _avoidTrafficJams) {
|				orders = _orders;
|				beginPoint = _beginPoint;
|				endPoint = _endPoint;
|				avoidTrafficJams = _avoidTrafficJams;

|				// отправляем запрос на получение адреса начальной и конечной точек
|				getPointAddress(beginPoint);
|				getPointAddress(endPoint);

|				// если кол-во точек (суммарно) < 2 нет смысла строить маршрут                
|				if ((orders.length + (beginPoint ? 1 : 0) + (endPoint ? 1 : 0)) < 2) {
|					return;
|				}

|				// если маршрут уже был построен, его необходимо подчистисть
|				if (isBuilt) {
|					clearRoutes();                
|				}

|				// список точек для построения маршрута
|				var points = getPointsForRoute();
|				
|				// отображаем индикатор загрузки маршрутов
|				onBeginBuild();

|				ymaps.route(points, {                    
|					avoidTrafficJams: avoidTrafficJams
|				})
|				.then(function (route) {
|					map.geoObjects.add(route);

|					routeOnMap = route;

|					// убираем (прячем) все метки. В принципе неправильно, но ...
|					routePoints = route.getWayPoints();
|					for (var j = 0; j < routePoints.getLength() ; j++) {
|						routePoints.get(j).options.set('visible', false);
|					}

|					// устанавливаем цвет линии маршрута
|					route.getPaths().options.set({
|						strokeColor: '#9400D3',
|						opacity: 0.8
|					});

|					// отображаем начальную и конечную точки
|					showBeginEndPoints();

|					// получаем информацию о маршруте
|					infoData = getRouteInfo();
|					info.moveList = infoData.moveList;
|					info.length   = infoData.length;
|					info.time     = infoData.time;

|					isBuilt = true;
|					onFinishBuild();    // прячем индикатор загрузки маршрутов
|				});
|			}

|			return this;
|		}

|		//***********************************************************************************************************************
|		//
|		//  Функции, текст которых формируется 1с-кой
|		//

|		// формируется 1с-кой
|		function ya_get_map() {
|			" + ТекстКарта + "
|		}

|		// формируется 1с-кой
|		function ya_get_placemarks(provider) {            
|			var order;
|			" + ТекстСписокЗаказов + "
|		}

|		// формируется 1с-кой
|		function ya_build_zones(map, placemarks) {                                    
|			var zoneInfo;
|			// Цикл 1с-ки
|			" + ТекстОбласти + "
|			// КонецЦикла 1с-ки
|		}

|		//***********************************************************************************************************************
|		//
|		//  Функции работы с картой
|		//

|		// Навешивание обработчиков событий карты. Стандартные кнопки управление карты. Прочие функции и параметры карты
|		function map_prepare(map) {
|			map.events.add('click', function (e) {                
|				zonesProvider.deselectZones();
|			});
|			map.behaviors.enable(['scrollZoom']);
|			// элементы управления карты
|			map.controls.add(new ymaps.control.MiniMap({ type: 'yandex#map' }, { zoomOffset: 4 }));
|			map.controls.add('zoomControl', { top: 40, left: 5 });
|		}

|		// Построение кластеризатора. (Задает параметры объединения точек в 1 круг, если точки находятся слишком близко)
|		function build_clusterer(map, placemarks) {
|			var clusterer = new ymaps.Clusterer({
|				preset: 'twirl#invertedVioletClusterIcons',     // TODO : цвет и тип можно вынести в параметры метода
|				groupByCoordinates: true,
|				clusterDisableClickZoom: true
|			});
|			clusterer.add(placemarks);
|			map.geoObjects.add(clusterer);
|		}

|		// Добавление кнопок: +зона
|		function add_zones_buttons() {
|			var buttonAdd = new ymaps.control.Button({
|			}, {
|				layout: ymaps.templateLayoutFactory.createClass(
|					""<div class='my-button [if state.selected]my-button-selected[endif]'>+зона</div>""
|				)
|			});
|			buttonAdd.events.add('click', function (e) {               
|				var color = get_color(zonesProvider.zones.length);
|				var newZone = {
|					coordinates: [],
|					fillColor: color,
|					hintContent: 'Зона ' + (zonesProvider.getMaxIndex() + 1),
|					zoneName: 'Зона ' + (zonesProvider.getMaxIndex() + 1)
|				};                

|				zonesProvider.addZone(newZone).startDrawing();                

|			});
|			myMap.controls.add(buttonAdd, {
|				right: 85,
|				top: 5
|			});
|		}

|		//***********************************************************************************************************************
|		//
|		//  Вспомагательные функции
|		//

|		// Цвета
|		function get_color(index) {
|			var colors = get_colors();
|			if (index > colors.length || index < 0) index = 0;
|			return colors[index];
|		}

|		// Список цветов палитры
|		function get_colors() {
|			var colors = [""#6699ff"", ""#A7CF62"", ""#8A62CF"", ""#F4F78F"", ""#0707E6"", ""#DDDDDD"", ""#888888"", ""#C72A2A""];
|			return colors;
|		}

|		//***********************************************************************************************************************
|		// 
|		// Функции, которые вызываются 1с-кой
|		// 

|		// Вызывается из 1с. Возвращает структуру 2-х массивов.
|		function js_getMappedOrders() {   
|			// по каждой зоне получаем список всех входящих точек
|			// по каждой точке ставим IdZone
|			var res;           // результирующая стурктура 2-х массивов
|			var zones = [];    // список зон
|			var points = [];   // список точек

|			var i;  // iterator

|			// очищаем айдишники зон точек
|			for (i = 0; i < placemarksProvider.getOrders().length; i++) {
|				placemarksProvider.getOrders()[i].zoneId = undefined;
|			}
|			for (i = 0; i < zonesProvider.zones.length; i++) {
|				// ставим айдишник для зоны
|				zonesProvider.zones[i].zoneId = i;
|				// вычисляем список входящих точек
|				var placemarksInZone = ymaps.geoQuery(placemarksProvider.getPlacemarks()).searchInside(zonesProvider.zones[i].ref);
|				for (var j = 0; j < placemarksInZone.getLength() ; j++) {
|					// ставим айдишник зоны, чтобы в 1с-ке привязать
|					var ref = placemarksInZone.get(j).properties.get('objRef');
|					if (ref) {
|						ref.zoneId = i;
|					}                   
|				};
|				// формируем массив зон
|				zones.push({
|					zoneId: zonesProvider.zones[i].zoneId,
|					vertexesArray: zonesProvider.zones[i].ref.geometry.getCoordinates()[0],
|					color: zonesProvider.zones[i].fillColor,
|					zoneCode1c: zonesProvider.zones[i].code1c,
|					zoneName: zonesProvider.zones[i].name
|				});
|			}
|			// формируем массив точек
|			for (i = 0; i < placemarksProvider.getOrders().length; i++) {
|				points.push({
|					doc1cCode: placemarksProvider.getOrders()[i].doc1cCode,
|					zoneId: placemarksProvider.getOrders()[i].zoneId
|				});
|			}
|			res = {
|				zones: zones,
|				points: points          // массив точек передаем, чтобы каждый адрес привязать к зоне
|			};
|			myData = res;
		//EFSOL_Сальник К.А. 2019-04-18 {+
|			var result = JSON.stringify(res); 
|			document.getElementById('result').innerHTML = result;
		//EFSOL_Сальник К.А.  -}
|			return res;
|		}

|		// вызывается из 1с-ки
		//EFSOL_Сальник К.А. 2019-04-18 {+
|		function js_setOrderState() {
|			var params = document.getElementById('params').innerHTML;
|			params = JSON.parse(params);
|			var doc1cCode = params.gid;
|			var state = params.label;
		//EFSOL_Сальник К.А.  -}
|			var order = placemarksProvider.findOrderByDoc1cCode(doc1cCode);            
|			if (order) order.setState(state);
|		}
|		// строит маршруты
		// EFSOL_Сальник К.А. 2019-04-18 {+
|		function js_build_routes() {
|			var params = document.getElementById('params').innerHTML;
|			params = JSON.parse(params);
|			var beginPointCoords = params.start;
|			var endPointCoords = params.end;
|			var avoidTrafficJams = params.pileup;
		//EFSOL_Сальник К.А.  -}
|			routerProvider.buildRoutes(placemarksProvider.getOrders(), beginPointCoords, endPointCoords, avoidTrafficJams);
|		}
		//EFSOL_Сальник К.А. 2019-04-18 {+
|		function js_getInfo_routes(){
|			var info = {
|				     moveList: myRouteMap.moveList,
|					 time: myRouteMap.time,
|					 length: myRouteMap.length
|			};
|			var result = JSON.stringify(info); 
|			document.getElementById('result').innerHTML = result;
|		}
		//EFSOL_Сальник К.А.  -}
|	   
|		window.onerror = function (msg, url, lno) { return true };
|	</script>
|</head>
|<body>
//|	<div id ='test'></div>
|	<div id='map' style='width: 100%; height: 100%; position: absolute'>
|		<div id=""route_process"" style=""position:absolute; left:10px; top: 10px;z-index:80000;color:red;display:none"">Поcтроение маршрута...</div>
|		<div id=""map_process"" style=""position:absolute; left:10px; top: 10px;z-index:80001;color:red;display:block"">Поcтроение карты...</div>
|	</div>
	// EFSOL_Сальник К.А. 2019-04-18 {+
|	<div id='params' style='display:none'></div>
|	<div id='result' style='display:none'></div>
|	<button id='js_setOrderState' style='display: none;' onclick='js_setOrderState()'></button>
|	<button id='js_getMappedOrders' style='display: none;' onclick='js_getMappedOrders()'></button>
|	<button id='js_build_routes' style='display: none;' onclick='js_build_routes()'></button>
|	<button id='js_getInfo_routes' style='display: none;' onclick='js_getInfo_routes()'></button>
	//EFSOL_Сальник К.А.  -}
|	<div id='order'></div>
|	<div style=""display:none"">" + Формат(ТекущаяДата(), "ггггММддЧЧммсс") + "</div>
|</body>
|</html> ";

Возврат html;

КонецФункции

// Шаблон формирования объекта-карты
Функция Я_ПолучитьТекстКарты(Параметры)
	
	Текст = "
	|	var map = new ymaps.Map('map', {
	|            center: [55.76, 37.64],                
	|            zoom: 10
	|        });";
	
	Если Параметры.Карта.Центр.Свойство("Адрес") Тогда
		
		ЦентрАдрес = Параметры.Карта.Центр.Адрес;
		// если центр задан строкой - адресом
		Текст = Текст + "
		 |ymaps.geocode('" + ЦентрАдрес + "').then(function (res) {
		 |	var newCenter = res.geoObjects.get(0);
		 |		if (newCenter) {
		 |			map.setCenter(newCenter.geometry.getCoordinates());
		 |		}         
		 |   });";
		
	Иначе
		
		// если центр задан координатами, тогда
		ЦентрДолгота = Параметры.Карта.Центр.Долгота;
		ЦентрШирота =  Параметры.Карта.Центр.Широта;
		Текст = Текст + "map.setCenter([" + ЦентрДолгота + "," + ЦентрШирота + "]);";
		
	КонецЕсли;		
	
	Текст = Текст + "
			|		document.getElementById('map_process').style.display = 'none';
			|		return map;";
	
	Возврат Текст;
	
КонецФункции

// Шаблон формирования списка заказов на карте
Функция Я_ПолучитьТекстФормированияТочекЗаказов(СписокЗаказов, Параметры)
	
	Текст = "";
	
	Для Каждого Заказ Из СписокЗаказов Цикл
		
		АдресЗаказа = "";
		Если Не Заказ.Свойство("АдресТекстом", АдресЗаказа) Тогда
			АдресЗаказа = Заказ.КраткоеОписание;
		КонецЕсли;
		
		Текст = Текст + "
		|			order = {
		|				coordinates: [" + Заказ.Координаты.Долгота + ", " + Заказ.Координаты.Широта + "],
		|				address: '" + УбратьнепечатаемыеСимволыВКарте(АдресЗаказа) + "',
		|				balloonBody: '" + УбратьнепечатаемыеСимволыВКарте(Заказ.КраткоеОписание) + "',		
		|				hintContent: '" + УбратьнепечатаемыеСимволыВКарте(Заказ.КраткоеОписание) + "',
		|				iconContent: '" + Заказ.Номер + "',		
		|				doc1cCode: '" + Заказ.Код1С + "',
		|				doc1cFlag: " + ПреобразоватьБулевоВJS(Заказ.Отметка) + ",
		|				pressHandle: " + ПреобразоватьБулевоВJS(Заказ.ОбработкаНажатия) + ",
		|        		routeUse: " + ПреобразоватьБулевоВJS(Заказ.ПостроениеМаршрута) + ",
		|				orderInfo: '" + УбратьнепечатаемыеСимволыВКарте(Заказ.ИнформацияОЗаказе) + "',
		|        		colorSet: " + ПреобразоватьБулевоВJS(Заказ.ЦветМетки) + ",
		|				colorLabel: '" + Заказ.Цвет + "',
		|				linked: " + ПреобразоватьБулевоВJS(Заказ.ВыделятьЦветом) + "	
		|			};
		|			provider.addOrder(order);";
				
	КонецЦикла;
	
	Возврат Текст;
	
КонецФункции



Функция УбратьнепечатаемыеСимволыВКарте(мСтрока) Экспорт
	
	Комментарий = СтрЗаменить(мСтрока,"¶","");
	Комментарий = СтрЗаменить (Комментарий, Символ(13), "");
	Комментарий = СтрЗаменить (Комментарий, Символы.ПС, "");
	Комментарий = СтрЗаменить(Комментарий,"'","");
	
	Возврат Комментарий;
	
КонецФункции

// Шаблон формирования областей на карте
Функция Я_ПолучитьТекстФормированияОбластей(СписокОбластей, Параметры)
	
	Текст = "";
	
	Для Каждого Область Из СписокОбластей Цикл
		
		// формируем строку из списока координат вершин области		
		СписокВершин = "";
		Для Каждого Вершина Из Область.СписокВершин Цикл			
			СписокВершин = СписокВершин + "[" + Вершина.Долгота + "," + Вершина.Широта + "],";
		КонецЦикла;					
		
		СписокВершин = Лев(СписокВершин, СтрДлина(СписокВершин) - 1);
		
		Текст = Текст + "
		|	zoneInfo = {
		|				coordinates: [" + СписокВершин + "],
		|				hintContent: '-----" + Область.Название + "',
		|				fillColor: '" + Область.Цвет + "',
		|				zoneCode1c: '" + Область.Код + "',
		|				zoneName: '" + Область.Название +"'
		|			};
		|			zonesProvider.addZone(zoneInfo);";
				
	КонецЦикла;	
	
	Возврат Текст;
	
КонецФункции

// Шаблон формирования текста html-контейнера для размещения елемента Яднекс-карты
Функция Я_ПолучитьТекстЭлементРазмещения(Параметры)
	
	Возврат "    <div id='map' style='width:" + Параметры.Карта.Размеры.Ширина + "px; height:" + Параметры.Карта.Размеры.Высота + "px'></div>    ";
	
КонецФункции

// Функция - обработчик, который следует вызывать в обработчике события Елемента формы карты.
Функция ОбработкаНажатия(ДанныеСобытия, РезультатОбработки)                                   	 ЭКСПОРТ
	
	// событие "проведения" (отметки) заказа
	Если ДанныеСобытия.Element.id = "order" Тогда
			
		// разбиваем строку ( по запятым) на элементы и формируем массив
		МногострочнаяСтрока = СтрЗаменить(ДанныеСобытия.Element.value, ",", Символы.ПС);
		
		Для итератор = 1 по СтрЧислоСтрок(МногострочнаяСтрока) Цикл
			
			// 0005=false
			ЗаказИнфо = СтрПолучитьСтроку(МногострочнаяСтрока, итератор);
			
			Если Не ЗначениеЗаполнено(ЗаказИнфо) Тогда 
				Продолжить; 
			КонецЕсли;
			
			Значения = РазбитьСтрокуПоСимволу(ЗаказИнфо, "=");					
			Код = Значения.Л;
			Статус = НРег(Значения.П);
			Если Статус = "true" Тогда 
				Статус = Истина;
			Иначе 
				Статус = Ложь;
			КонецЕсли;
			
			РезультатОбработки.Добавить(Новый Структура("КодДокумента,Статус", Код, Статус));
		КонецЦикла;
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ОтметитьЗаказНаКарте(Документ, КодЗаказа, Отметка)											 ЭКСПОРТ
	//EFSOL_Сальник К.А. 2019-04-18 {+
	Попытка
	Параметры = Новый Структура;
	Параметры.Вставить("gid",КодЗаказа);
	Параметры.Вставить("label",Отметка);
	Результат = ES_JSON.ЗаписатьJSON_(Параметры);
	Результат = ES_OpenStreetMap.УбратьнепечатаемыеСимволыВКарте(Результат);
	Документ.getElementById("params").innerHTML = Результат;
	Документ.getElementById("js_setOrderState").fireEvent("onclick");	
	
	//Dom.eval("js_setOrderState('" + КодЗаказа + "', " + ПреобразоватьБулевоВJS(Статус) + ")");			
	Исключение
		Сообщить("Обновите карту");
	КонецПопытки;
	//EFSOL_Сальник К.А.  -}	
КонецФункции

//
Функция ПостроитьМаршруты(Документ, Параметры)														 ЭКСПОРТ
	//EFSOL_Сальник К.А. 2019-04-18 {+
	ПараметрыМаршрута = Новый Структура;
	Если Параметры.Свойство("НачальнаяТочка") Тогда
		Координаты = Новый Массив;
		Координаты.Добавить(Параметры.НачальнаяТочка.Долгота);
		Координаты.Добавить(Параметры.НачальнаяТочка.Широта);

		ПараметрыМаршрута.Вставить("start", Координаты);
	Иначе 
		ПараметрыМаршрута.Вставить("start", null);
	КонецЕсли;
	Если Параметры.Свойство("КонечнаяТочка") Тогда
		Координаты = Новый Массив;
		Координаты.Добавить(Параметры.КонечнаяТочка.Долгота);
		Координаты.Добавить(Параметры.КонечнаяТочка.Широта);

		ПараметрыМаршрута.Вставить("end", Координаты);
	Иначе 
		ПараметрыМаршрута.Вставить("end", null);
	КонецЕсли;	        	
	Если Параметры.Свойство("УчитыватьПробки") И Параметры.УчитыватьПробки Тогда
		ПараметрыМаршрута.Вставить("pileup", Истина);
	Иначе
		ПараметрыМаршрута.Вставить("pileup", Ложь);
	КонецЕсли;
	
	Результат = ES_JSON.ЗаписатьJSON_(ПараметрыМаршрута);
	Результат = ES_OpenStreetMap.УбратьнепечатаемыеСимволыВКарте(Результат);
	Документ.getElementById("params").innerHTML = Результат;
	Документ.getElementById("js_build_routes").fireEvent("onclick");
	//EFSOL_Сальник К.А.  -}
КонецФункции

//
Функция ПолучитьОбластиВЗонах(Документ)        														 ЭКСПОРТ
	
	// заполняем значение глобальной переменной
	
	//EFSOL_Сальник К.А. 2019-04-18 {+
	Документ.getElementById("result").innerHTML = "started";
	Документ.getElementById("js_getMappedOrders").fireEvent("onclick");
	Результат = Документ.getElementById("result").innerHTML;
	Пока Результат = "started" Цикл
		Результат = Документ.getElementById("result").innerHTML;
	КонецЦикла;
	Результат = ES_JSON.ПрочитатьJSON_(Результат);
		
	//Dom.eval("js_getMappedOrders()");
	//Элементы.Карта.Документ.getElementById("map")
	
	РезультатДанные = Новый Структура("Области,Метки", Новый Массив(), Новый Массив());
	
	// формирует список областей	
	КолВоОбластей = Результат.Получить("zones").Количество();
	Для ОбластьИндекс = 0 По КолВоОбластей - 1 Цикл		
		Область = Новый Структура("Айди,Код1С,Цвет,Координаты,Название");
		Область.Код1С = Результат.Получить("zones")[ОбластьИндекс].Получить("zoneCode1c");
		Область.Цвет = Результат.Получить("zones")[ОбластьИндекс].Получить("color");
		Область.Айди = Результат.Получить("zones")[ОбластьИндекс].Получить("zoneId");
		Область.Название = Результат.Получить("zones")[ОбластьИндекс].Получить("zoneName");
		Область.Координаты = Новый Массив();
		// читаем список координат
		КолВоКоординатОбласти = Результат.Получить("zones")[ОбластьИндекс].Получить("vertexesArray").Количество();
		
		Для ВершинаИндекс = 0 По КолВоКоординатОбласти -  1 Цикл 
			
			ВершинаОбласти = Новый Структура("Долгота, Широта", 
			Результат.Получить("zones")[ОбластьИндекс].Получить("vertexesArray")[ВершинаИндекс][0],
			Результат.Получить("zones")[ОбластьИндекс].Получить("vertexesArray")[ВершинаИндекс][1]);
			Область.Координаты.Добавить(ВершинаОбласти);
	
		КонецЦикла;
		
		РезультатДанные.Области.Добавить(Область);
	КонецЦикла;
	
	// формируем список меток по областям
	КолВоМеток = Результат.Получить("points").Количество();
	Для ИндексМекта = 0 По КолВоМеток - 1 Цикл
		Метка = Новый Структура("КодДокумента,АйдиЗоны",
		Результат.Получить("points")[ИндексМекта].Получить("doc1cCode"),
		Результат.Получить("points")[ИндексМекта].Получить("zoneId"));
		
		РезультатДанные.Метки.Добавить(Метка);
	КонецЦикла;
	
	Возврат РезультатДанные;
	//EFSOL_Сальник К.А.  -}
	
КонецФункции	

//
Функция ПолучитьОписаниеМаршрута(Документ) 															 ЭКСПОРТ
	//EFSOL_Сальник К.А. 2019-04-18 {+
	Документ.getElementById("js_getInfo_routes").fireEvent("onclick");	
	Результат = Документ.getElementById("result").innerHTML;
	Результат = ES_JSON.ПрочитатьJSON_(Результат);
	
	Возврат Новый Структура("Текст,Время,Дистанция",
					Результат.Получить("moveList"),
					Результат.Получить("time"),
					Результат.Получить("length"));
	//EFSOL_Сальник К.А.  -}		
КонецФункции


////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Функции работы с формой выбора адреса (метка, координаты, адрес)
// 


//
Функция ПолучитьТекстКартыВыбораАдреса(Параметры) 												  ЭКСПОРТ
	
	Долгота = Параметры.Долгота;
	Широта = Параметры.Широта;
	
	// формируем основной текст карты
	
	
	Текст = "<!DOCTYPE html>
	|<html>
	|<head>
	//|	<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	|	<meta http-equiv='X-UA-Compatible' content='IE=8' />
	|	<title>Примеры. Размещение карты на странице.</title>
	|	<script src='http://api-maps.yandex.ru/2.0-stable/?load=package.full&lang=ru_RU' type='text/javascript'></script>
	|	<script type='text/javascript'>
	|		var myAddress;
	|		var myLng;
	|		var myLats;
	|		var myMap;
	|		
	|		ymaps.ready(init);
	|		
	|		// Инициализация (кэп)
	
	|		function init() {
	|			// создаем карту
	|			myMap = ya_get_map();
	|		}
	
	|		// формируется 1с-кой
	|		function ya_get_map() {
	|			var center = [" + Долгота + ", " + Широта + "];                    
	
	|			var map = new ymaps.Map('map', {
	|				center: center,                
	|				zoom: 10
	|			});
	
	|			var placemark = new ymaps.Placemark(
	|				center, {
	|					hintContent: 'Передвиньте метку на нужный адрес'                    
	|				},{
	|					preset: 'twirl#yellowDotIcon',
	|					draggable: true                    
	|				}
	|			);
		
	|			refreshAddress = function () {
	|				ymaps.geocode(placemark.geometry.getCoordinates(), { kind: 'house' }).then(function (res) {
	|					var obj = res.geoObjects.get(0);
	|					if (!obj) return;
	|					var address = obj.properties.get('text');
	|					var coords = obj.geometry.getCoordinates();
	|					display_point_position(address, coords[0], coords[1]);
	|					addmetro(coords);

	|				});
	|			};
	//ЕФСОЛ Несторук 05.08.2016 + 
	|			 addmetro = function(coords) {
	|					ymaps.geocode(coords, {kind: 'metro'}).then (function (res) {
	|					var obj = res.geoObjects.get(0);
	|					if (!obj) return;
	|					var metro = obj.properties.get('name');
	|					var metrocoords = obj.geometry.getCoordinates();
	|					display_metro(metro);
	|					findroute(coords, metrocoords);
	|                   	
	
	|					});
	|			};
	|			function findroute(coords,metrocoords){
	|							ymaps.route([coords, metrocoords]).then (function (route) {
    |                   		var routedistance = route.getLength();
	|							//map.geoObjects.add(route);
	|					    	display_distance(routedistance);
	|							});
	|			};
	
	//ЕФСОЛ Несторук 05.08.2016 -
	|			placemark.events.add('drag', function (e) {
	|				//                
	|				refreshAddress();

	|			});

	|			map.geoObjects.add(placemark);
	
	|			map.controls.add(new ymaps.control.MiniMap({ type: 'yandex#map' }, { zoomOffset: 4 }));
	|			map.controls.add('zoomControl', { top: 40, left: 5 });

	|			refreshAddress();

	|			return map;
	|		}
	
	|		// 
	|		function display_point_position(address, lng, lat) {
	|			document.getElementById('address').innerHTML = address;
	|			document.getElementById('lng').innerHTML = lng;
	|			document.getElementById('lat').innerHTML = lat;
	|		}
	|		
		//ЕФСОЛ Несторук 05.08.2016 +
	|			function display_metro(metro) {
	|			document.getElementById('metro').innerHTML = metro;
	|		};
	|			function display_distance(routedistance) {
	|			document.getElementById('routedistance').innerHTML = routedistance;
	|		};
		//ЕФСОЛ Несторук 05.08.2016 
	
	|		window.onerror = function (msg, url, lno) {return true};
	|	</script>
	|</head>
	|	<body bgcolor=#FCFAEB>
	|		<div id='infoPanel'>
	|			<i><small id='markerStatus'>Для корректировки текущего местоположения адреса доставки переместите маркер в необходимое место...</small></i><br />
	|			<b>Текущие координаты: </b>(<small id='lng'>0</small>, <small id='lat'>0</small>)<br />
	|			<b>Текущий адрес: </b><small id='address'>...</small><br /><br /> 
				//ЕФСОЛ Несторук 05.08.2016 +
	|			<b>Ближайшая станция метро: </b><small id='metro'>...</small>, <small id='routedistance'>0</small> <br /><br /> 
				//ЕФСОЛ Несторук 05.08.2016 -

	|		</div>
	|		<div id='map' style='width: 100%; height: 100%; position: absolute'></div>
	|	</body>
	|</html> ";
	
	Возврат Текст;
	
КонецФункции	

//
Функция ПолучитьКоординаты(Dom)              													  ЭКСПОРТ
	
	Долгота = Dom.eval("lng").innerHtml;
	Широта = Dom.eval("lat").innerHtml;
	Адрес = Dom.eval("address").innerHtml;
	
	Возврат Новый Структура ("Долгота,Широта,Адрес", Долгота, Широта, Адрес);
	
КонецФункции	


////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Работы с геокодированием (получение координат по адресу и адреса по координатам)
// 


//
&НаСервере
Функция ГеокодированияПолучитьКоординаты(АдресТекстом)											  ЭКСПОРТ
	
	Координаты = Новый Структура ("Долгота,Широта,Страна,Индекс,Область,Город,Улица,Дом,Корпус,Строение,Квартира");
	
	//EFSOL_Шаповал получение координат через гугл
	
	Гугл = Ложь; 
	Яндекс = Истина; //поставл яндекс по умолчанию
	ОпенСтритМап = Ложь;
	//ЕФСОЛ Несторук 08.08.2016 +
	ТекСистемаОпределенияКоординат = ES_ОбщегоНазначения.ПолучитьСтартовуюНастройку(ПредопределенноеЗначение("Перечисление.ES_ВидыСтартовыхНастроек.СистемаОпределенияКоординат")) ;
	Гугл = ТекСистемаОпределенияКоординат = ПредопределенноеЗначение("Перечисление.ES_СистемыОпределенияКоординат.Google");
	Яндекс = ТекСистемаОпределенияКоординат = ПредопределенноеЗначение("Перечисление.ES_СистемыОпределенияКоординат.Yandex");
	ОпенСтритМап = ТекСистемаОпределенияКоординат = ПредопределенноеЗначение("Перечисление.ES_СистемыОпределенияКоординат.OpenStreetMap");
    //ЕФСОЛ Несторук 08.08.2016 -	
	
	Если Яндекс Тогда
		АдресСервера = "geocode-maps.yandex.ru";
		АдресРесурса = "1.x/?"+ПараметрыСеанса.ES_APIКлючЯндекса+"geocode=" + АдресТекстом + "&format=xml&results=1";
	ИначеЕсли Гугл Тогда
		АдресСервера = "maps.googleapis.com";
		АдресРесурса = "maps/api/geocode/xml?address=" + АдресТекстом + "&sensor=true_or_false";
	ИначеЕсли ОпенСтритМап Тогда
		АдресСервера = "nominatim.openstreetmap.org";
		АдресРесурса = "search?q=" + АдресТекстом + "&format=xml&addressdetails=1&limit=1";
	КонецЕсли;
	
	Попытка
		
		Соединение = Новый HTTPСоединение(АдресСервера,,,,,,Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(),
		Новый СертификатыУдостоверяющихЦентровWindows()
		)
		);
		
	Исключение
		
		Возврат Координаты;
		
	КонецПопытки;
	
	//ФайлРезультата = ПолучитьИмяВременногоФайла();
	СтрокаРезультат = "";
	Попытка
		HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
		Ответ = Соединение.Получить(HTTPЗапрос);
		СтрокаРезультат = Ответ.ПолучитьТелоКакСтроку();

		Соединение = Неопределено;
	Исключение
		
		Возврат Координаты;
		
	КонецПопытки;
	
	ЧтениеXML   = Новый ЧтениеXML;
	//ЧтениеXML.ОткрытьФайл(ФайлРезультата); 
	ЧтениеXML.УстановитьСтроку(СтрокаРезультат);
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.Имя = "pos" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = РазбитьСтрокуПоСимволу(ЧтениеXML.Значение, " ");
				Координаты.Широта  = Данные.Л;
				Координаты.Долгота = Данные.П;
				Прервать;
				
			КонецЕсли;
		//EFSOL_Сальник К.А. 2018-11-21 {+	
		ИначеЕсли ЧтениеXML.Имя = "CountryName" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				Координаты.Страна  = Данные;
				
			КонецЕсли;
		ИначеЕсли ЧтениеXML.Имя = "AdministrativeAreaName" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				Координаты.Область  = Данные;
				
			КонецЕсли;
		ИначеЕсли ЧтениеXML.Имя = "LocalityName" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				Координаты.Город  = Данные;
				
			КонецЕсли;
		ИначеЕсли ЧтениеXML.Имя = "PostalCodeNumber" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				Координаты.Индекс  = Данные;
								
			КонецЕсли;
		ИначеЕсли ЧтениеXML.Имя = "ThoroughfareName" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				Координаты.Улица  = Данные;
				
			КонецЕсли;
		ИначеЕсли ЧтениеXML.Имя = "PremiseNumber" И Яндекс Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = ЧтениеXML.Значение;
				Если Найти(Данные,"/") <> 0 Тогда   
					Данные = РазбитьСтрокуПоСимволу(ЧтениеXML.Значение, "/");
					Координаты.Дом  = Данные.Л;
					Координаты.Строение  = Данные.П;
				Иначе
					Координаты.Дом = Данные;
				КонецЕсли;				
				
			КонецЕсли;
		//EFSOL_Сальник К.А.  -}
		ИначеЕсли ЧтениеXML.Имя = "location" И Гугл Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.Имя = "lat" Тогда
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
					//ЧтениеXML.Прочитать();
					//Данные = РазбитьСтрокуПоСимволу(ЧтениеXML.Значение, " ");
					Координаты.Долгота  = ЧтениеXML.Значение;
					//Координаты.Широта = ЧтениеXML.Значение;
					//Прервать;
					ЧтениеXML.Прочитать(); 
				КонецЕсли;
			КонецЕсли;
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.Имя = "lng" Тогда
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
					//ЧтениеXML.Прочитать();
					//Данные = РазбитьСтрокуПоСимволу(ЧтениеXML.Значение, " ");
					//Координаты.Долгота  = ЧтениеXML.Значение;
					Координаты.Широта = ЧтениеXML.Значение;
					Прервать;
					//ЧтениеXML.Прочитать(); 
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ЧтениеXML.Имя = "place" И ОпенСтритМап Тогда
			Координаты.Широта  = ЧтениеXML.ПолучитьАтрибут("lat");
			Координаты.Долгота = ЧтениеXML.ПолучитьАтрибут("lon");
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	// удалить временный файл!
	
	Возврат Координаты;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Служебные функции 
// 


// Проверка интернета. Попытка зайти на страницу яндекса
&НаСервере
Функция ПроверкаИнтернет() ЭКСПОРТ
	
	Попытка
		Соединение = Новый HTTPСоединение("ya.ru");
		Данные = Соединение.Получить("/", ПолучитьИмяВременногоФайла());
		Возврат Истина;
	Исключение
		
		Возврат Ложь;
	КонецПопытки; 
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Дополнительные (вспомогательные) функции 
// 


// Функция преобразовывает 1с-е булево в строковое ("true"/"false") для формирования текста скрипта
Функция ПреобразоватьБулевоВJS(Значение)
	
	Возврат ? (Значение, "true", "false");
	
КонецФункции

//	
Функция РазбитьСтрокуПоСимволу(Текст, Символ)
	
	ПозСимвол = Найти(Текст, Символ);
	Л = Лев(Текст, ПозСимвол - 1);
	П = НРег(Прав(Текст, СтрДлина(Текст) - ПозСимвол));
	
	Возврат Новый Структура("Л,П", Л,П);
	
КонецФункции

//ЕФСОЛ Несторук 05.08.2016 +
Функция ПолучитьМетро(Dom)              													  ЭКСПОРТ
	
	Метро = Dom.eval("metro").innerHtml;
	Расстояние = Dom.eval("routedistance").innerHtml;
		
	Возврат Новый Структура ("Метро,Расстояние", Метро, Расстояние);
	
КонецФункции
//ЕФСОЛ Несторук 05.08.2016 -

//ЕФСОЛ Несторук 05.08.2016 +//обратное геокодирование
&НаСервере
Функция ГеокодированияПолучитьКоординатыМетро(СтруктураГеокодирования)											  ЭКСПОРТ
	
	Координаты = Новый Структура ("Долгота,Широта,Имя,ЛинияМетро");
	
	АдресСервера = "geocode-maps.yandex.ru";
	АдресРесурса = "1.x/?"+ПараметрыСеанса.ES_APIКлючЯндекса+"geocode=" +СтруктураГеокодирования.Широта + ","+ СтруктураГеокодирования.Долгота + "&kind=metro&format=xml&results=1";
	
	Попытка
		
		Соединение = Новый HTTPСоединение(АдресСервера,,,,,,Новый ЗащищенноеСоединениеOpenSSL(
            												Новый СертификатКлиентаWindows(),
            												Новый СертификатыУдостоверяющихЦентровWindows()
															                                  )
										 );
		
	Исключение
				
		Возврат Координаты;
		
	КонецПопытки;
	
	ФайлРезультата = ПолучитьИмяВременногоФайла();
	
	Попытка
		
		Соединение.Получить(АдресРесурса, ФайлРезультата);
		Соединение = Неопределено;
		
	Исключение
				
		Возврат Координаты;
		
	КонецПопытки;
	
	ЧтениеXML   = Новый ЧтениеXML;
 	ЧтениеXML.ОткрытьФайл(ФайлРезультата);	
	
	Пока ЧтениеXML.Прочитать() Цикл
		
 		Если ЧтениеXML.Имя = "pos" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Данные = РазбитьСтрокуПоСимволу(ЧтениеXML.Значение, " ");
				Координаты.Широта  = Данные.Л;
				Координаты.Долгота = Данные.П;
									
			КонецЕсли;
			
		КонецЕсли;
		
		 Если ЧтениеXML.Имя = "name" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Координаты.Имя = ЧтениеXML.Значение;
									
			КонецЕсли;
			
		КонецЕсли;
		//ЭР Несторук С.И. 30.01.2017 17:37:09 {
		Если ЧтениеXML.Имя = "ThoroughfareName" Тогда
			ЧтениеXML.Прочитать();
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				Координаты.ЛинияМетро = ЧтениеXML.Значение;
				
			КонецЕсли;
			
		КонецЕсли;
		
		//ЭР Несторук С.И. 30.01.2017 17:37:09 }

	КонецЦикла;
		
 	ЧтениеXML.Закрыть();
		
	// удалить временный файл!
	УдалитьФайлы(ФайлРезультата);
	Возврат Координаты;
	
КонецФункции
//ЕФСОЛ Несторук 05.08.2016 -

