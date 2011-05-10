/**
 * Created by TBMS.
 * User: Aaron Karper <akarper@students.unibe.ch>
 * Date: 5/9/11
 * Time: 3:24 PM
 * To change this template use File | Settings | File Templates.
 *
 * kudos: http://www.mkyong.com/jquery/how-to-add-remove-textbox-dynamically-with-jquery/
 */

$(document).ready(function(){
     var counter;
    for (counter = 1; counter < 20; counter++) {
        var node = $("#TextBoxDiv"+counter);
        if ( !node.is(":visible")) {
            break;
        }
    }

    $("#addInfo").click(function () {

	$("#TextBoxDiv" + counter).show();

	counter++;
     });

     $("#removeInfo").click(function () {
	if(counter<1){
          alert("No more textbox to remove");
          return false;
       }

	counter--;

    $("#TextBoxDiv" + counter).hide();
    $("#key_" + counter).val("");
    $("#value_" + counter).val("");

     });
  });