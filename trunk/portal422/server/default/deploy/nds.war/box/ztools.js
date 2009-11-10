var ztools=null;
var ZTOOLS=Class.create();
ZTOOLS.prototype={
    initialize:function(){
        
    },
    /*
    * 合并数组中重复的元素
    * arr:目标数组、
    * return 合并后的集合 */
    mergeArr:function(arr){
       var len=arr.length;
       for(var i=0;i<len;i++){
           if(i<arr.length-1){
               arr=this._removeSameEle(arr,i);
           }
       }
        return arr;
    },
    /*删除指定下标元素右边相同的元素
    * arr:目标数组
    * num:指定的下标*/
    _removeSameEle:function(arr,num){
        var reArr=new Array();
        for(var i=0;i<arr.length;i++){
            if(i>num&&arr[i]==arr[num]){
                reArr.push(i);
            }
        }
        for(var j=0;j<reArr.length;j++){
            arr=arr.slice(0,reArr[j]-j).concat(arr.slice(reArr[j]-j+1));
        }
        return arr;
    }
}
ZTOOLS.main=function(){
    ztools=new ZTOOLS();
};
jQuery(document).ready(ZTOOLS.main);