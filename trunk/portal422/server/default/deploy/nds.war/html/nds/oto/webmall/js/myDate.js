var dater = function(_year,_month,_date,defaultYear, defaultMonth, defaultDate){
	var year = $(_year);
	var month = $(_month);
	var date = $(_date);
	var MonHead = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	
	function cmbSelect(cmb, str)
	{
		for(var i=0; i<cmb.children().length; i++)
		{
			if(cmb.children()[i].value == str)
			{
				cmb.children()[i].selected=true;
				return;
			}
		}
	}
	
	function IsPinYear(year){//判断是否闰平年
		return (0 == year % 4 && (year % 100 != 0 || year % 400 == 0))
	}
	
	function writeMonth(n){
		var strMonth="<option value='-1'>月份</option>\r\n";
		for (var i = 1; i < n; i++) {
        strMonth += "<option value='" + i + "'> " + i + " 月" + "</option>\r\n";
		}
		month.html(strMonth);
	}
	
	function writeDay(n){
		var strDate="<option value='-1'>日期</option>";
		for (var i = 1; i < (n + 1); i++) 
		strDate += "<option value='" + i + "'> " + i + " 日" +"</option>\r\n";
		date.html(strDate);
	}
	
	function changeYear(){
		//var monthSelect = month.val();
		var yearSelect = year.val();
		var n = MonHead[0];
		if(yearSelect == maxY){
			writeMonth(maxM+1);
		}else{
			writeMonth(13);
		}
		//if (monthSelect == 2 && IsPinYear(yearSelect)) n++;
		writeDay(n);
	}
	
	function changeMonth(){
		var monthSelect = month.val();
		var yearSelect = year.val();
		var n = MonHead[monthSelect - 1];
		if(monthSelect == maxM && yearSelect == maxY){
			n = maxD;
		}
		if (monthSelect == 2 && IsPinYear(yearSelect)) n++;
		writeDay(n);
	}
		
	var maxY = new Date().getFullYear();
	var maxM = new Date().getMonth()+1;
	var maxD = new Date().getDate();
	var strYear="<option value='-1'>年份</option>\r\n";
	for (var i = (maxY - 80); i < (maxY + 1); i++) //以今年为准，前30年，后30年
    {
        strYear += "<option value='" + i + "'> " + i + " 年" + "</option>\r\n";
    }
	year.html(strYear);
	
	if(defaultYear == maxY && defaultMonth == maxM){
		writeMonth(maxM+1);
	}else{
		writeMonth(13);
	}
	
	var n = MonHead[0];
	if(defaultYear == maxY && defaultMonth == maxM && defaultDate == maxD){
		n = maxD;
		writeDay(n);
	}else{
		writeDay(n);
	}
	
	year.change(function(){
		changeYear();
	});
	
	month.change(function(){
		changeMonth();
	});
	
	cmbSelect(year,defaultYear);
	cmbSelect(month,defaultMonth);
	cmbSelect(date,defaultDate);
}