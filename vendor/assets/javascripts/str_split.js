/*
 * https://gist.github.com/bbogovich/2611473
 * String.split(delimiter,limit)
 * Override Internet Explorer implementation of String.split to handle regular
 * expression capture groups in the same manner as all other browsers.  Each
 * capture group in the matched text will be included in the split array.
 */
if("a'b".split(/(')/g).length==2){
  String.prototype.split = function(delimiter/*,limit*/){
    if(typeof(delimiter)=="undefined"){
      return [this];
    }
    var limit = arguments.length>1?arguments[1]:-1;
    var result = [];
    if(delimiter.constructor==RegExp){
      delimiter.global = true;
      var regexpResult,str=this,previousIndex = 0;
      while(regexpResult = delimiter.exec(str)){
        result.push(str.substring(previousIndex,regexpResult.index))
        for (var captureGroup=1,ct=regexpResult.length;captureGroup<ct;captureGroup++){
          result.push(regexpResult[captureGroup]);
        }
        str=str.substring(delimiter.lastIndex,str.length);
      }
      result.push(str);
    }else{
      var searchIndex=0,foundIndex=0,len=this.length,dlen=delimiter.length;
      while(foundIndex!=-1){
        foundIndex = this.indexOf(delimiter,searchIndex);
        if(foundIndex!=-1){
          result.push(this.substring(searchIndex,foundIndex))
          searchIndex = foundIndex+dlen;
        }else{
          result.push(this.substring(searchIndex,len));
        }
      }
    }
    if(arguments.length>1&&result.length>limit){
      result = result.slice(0,limit);
    }
    return result;
  }
}
