Browse:
<input type="text" id="text1"/>
<script>
  var win;
  
  // ini fungsi menangkap return value (hasil) dari browse window
  // return value sebaiknya json format
  function setWindowResult(returnValue) {
    //targetField.value = returnValue;
    //$('.inner').html(returnValue);
    window.focus();
    win.close();
    alert(returnValue.ID);
    $('#text1').val(returnValue.ID);
  }
  
  (function($){
    $('#text1').on('click', function(){      
      win = window.open('browse/window/Customer', 'MyWindow', "menubar=0,toolbar=0,width=600,height=400");
      // other example:
      //win = window.open('browse/window/Team', 'MyWindow', "menubar=0,toolbar=0,width=600,height=400");
    });
  })(jQuery);
</script>
