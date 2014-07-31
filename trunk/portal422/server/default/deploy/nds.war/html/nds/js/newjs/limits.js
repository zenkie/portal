
	var limits = function(num, max, min){
		if(num >= max){
			return max;
		}
		else if(num <= min){
			return min;
		}
		else{
			return num;
		}
	};