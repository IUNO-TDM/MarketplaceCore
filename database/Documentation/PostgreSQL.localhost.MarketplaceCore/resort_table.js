var isFireFox = null;
var isOpera = (navigator.userAgent.match(/\bOpera\b/) != null);
var sorts = Object();

function stringStartsWith(string, prefix) {
    return string.slice(0, prefix.length) == prefix;
}

sorts.ts_conv_currency = function (a) {
    if (stringStartsWith(a, 'NaN')) return 0;
    if (a == '(n/a)' || a == 'NULL' || a == '' || a == ' ') return 0;
    if (a == 'max') return 2147483647; 
    return parseFloat(a.replace(/[^0-9.]/g, ''));
}

sorts.ts_conv_number = function(a) {
    if (stringStartsWith(a, 'NaN')) return 0;
    if (a == '(n/a)' || a == 'NULL' || a == '' || a == ' ') return 0;
    if (a == 'max') return 2147483647;
    x = a.toLowerCase().replace('kb','').replace('mb','').replace('gb','').replace(/[ ,b]/g,'')
    return parseFloat(x);
}

sorts.ts_conv_text = function (a) {
	return a.toLowerCase();
}

sorts.ts_sort_textCS = function (a) {
	return a;
}

//var months_ = Object();
//months_.Jan = 1;
//months_.Feb = 2;
//months_.Mar = 3;
//months_.Apr = 4;
//months_.May = 5;
//months_.Jun = 6;
//months_.Jul = 7;
//months_.Aug = 8;
//months_.Sep = 9;
//months_.Oct = 10;
//months_.Nov = 11;
//months_.Dec = 12;
//sorts.ts_conv_date = function(s) {
//	var a = s.match(/^(\w+) (\d+) (\d+) (\d+):(\d+)(AM|PM)/);
//	if (a == null) return;
//	a[4] = (a[4] % 12) + (a[6] == 'PM' ? 12 : 0);
//	return a[3]+'-'+months_[a[1]]+'-'+a[2]+' '+a[4]+':'+a[5];
//}

// bug fix from Jenda, see: http://elsasoft.com/forum/topic.asp?TOPIC_ID=321
var months_ = Object();
months_.Jan = '01';
months_.Feb = '02';
months_.Mar = '03';
months_.Apr = '04';
months_.May = '05';
months_.Jun = '06';
months_.Jul = '07';
months_.Aug = '08';
months_.Sep = '09';
months_.Oct = '10';
months_.Nov = '11';
months_.Dec = '12';

sorts.ts_conv_date100 = function(s) {
    var a = s.match(/^(\w+) (\d+) (\d+) (\d+):(\d+)(AM|PM)/);
    if (a == null) return s;
    a[4] = (a[4] % 12) + (a[6] == 'PM' ? 12 : 0);
    if (a[2].length == 1) { a[2] = '0' + a[2] }
    if (a[4].length == 1) { a[4] = '0' + a[4] }
    if (a[5].length == 1) { a[5] = '0' + a[5] }
    return a[3] + '-' + months_[a[1]] + '-' + a[2] + ' ' + a[4] + ':' + a[5];
}


function resortTable( tbl, column, desc, sortType) {
	if (isFireFox == null) {
		isFireFox = (tbl.tBodies[0].innerText == null);
	}

	//if (isFireFox) column = column*2 + 1;

	var tHeading = tbl.tHead.childNodes[0].childNodes[column];
	var tBody = tbl.tBodies[0];
	var Rows = tBody.rows;
	var len = Rows.length;

	if (desc == 2) {
		for (var i=0; i < len; i++) {
			Rows[i].childNodes[column].hiddenInnerHTML = Rows[i].childNodes[column].innerHTML;
			Rows[i].childNodes[column].innerHTML = "";//"&nbsp;";
		}

		tHeading.hiddenText = (isFireFox ? tHeading.textContent : tHeading.innerText);
		tHeading.innerHTML = '<img src="../expand.gif">';

		tHeading.style["padding"]="0px 0px 0px 0px";
	} else if (desc == 3) {
		values = tHeading.Values;
		for (var i=0; i < len; i++) {
//alert(Rows[i].childNodes[column].hiddenInnerHTML);
			Rows[i].childNodes[column].innerHTML = Rows[i].childNodes[column].hiddenInnerHTML;
			Rows[i].childNodes[column].hiddenInnerHTML = null;
		}

		if (isFireFox) {
			tHeading.textContent = tHeading.hiddenText;
		} else {
			tHeading.innerText = tHeading.hiddenText;
		}
		tHeading.style["padding"]="4px 6px";
		tHeading.Values = null;
		return;
	} else {
		var convFun = (sorts["ts_conv_" + sortType] || sorts.ts_conv_text);

		var values = Array();
		var rows = Array();
		var textValue;
		for (var i=0; i < len; i++) {
			textValue = Rows[i].childNodes[column]
			if (isFireFox) {
				textValue = textValue.textContent;
			} else {
				textValue = textValue.innerText;
			}
			values[i] = convFun(textValue);
			rows[i] = Rows[i].cloneNode(true);
			if (isOpera) {
				for (var col = 0; col < Rows[i].childNodes.length; col++) {
					if (Rows[i].childNodes[col].hiddenInnerHTML != null) {
						rows[i].childNodes[col].hiddenInnerHTML = Rows[i].childNodes[col].hiddenInnerHTML;
					}
				}
			}
		}

		var tmp;

		if (desc) {
			for (var i=len-1; i > 0; i--) {
			 for (var j=0; j < i; j++) {
			  if (values[j] > values[j+1]) {
			   tmp = values[j];
			   values[j] = values[j+1];
			   values[j+1] = tmp;
			   tmp = rows[j];
			   rows[j] = rows[j+1];
			   rows[j+1] = tmp;
			  }
			 }
			}
		} else {
			for (var i=len-1; i > 0; i--) {
			 for (var j=0; j < i; j++) {
			  if (values[j] < values[j+1]) {
			   tmp = values[j];
			   values[j] = values[j+1];
			   values[j+1] = tmp;
			   tmp = rows[j];
			   rows[j] = rows[j+1];
			   rows[j+1] = tmp;
			  }
			 }
			}
		}
		while (Rows.length > 0) {
			tBody.deleteRow(Rows.length-1);
		}
		for (var i=0; i < len; i++) {
			tBody.appendChild( rows[i]);
		}
	}
}

function resortColumn( col ) {
	if (col.sortOrder == null) col.sortOrder = 0;
	var sortType = (col.attributes["sortType"] == null ? null : col.attributes["sortType"].value)
	resortTable(col.parentNode.parentNode.parentNode, col.cellIndex, col.sortOrder, sortType);
	col.sortOrder = (col.sortOrder+1) % 4;
}
