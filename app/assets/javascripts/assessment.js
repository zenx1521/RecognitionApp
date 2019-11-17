window.Assessment = (function(){
    return {
        run : run  
    }

    function run(){
        $(document).ready(() => {
            var isSinglePoint = $('.is_session_single_point').data("singlePoint");
            var hide = false;
            var colorPickerHide = false;
            var isOnLast = false;
            var startingPointsColor = "red";
            var picker = $.farbtastic("#colorpicker");
            picker.setColor("#b6b6ff"); //set initial color
            picker.linkTo(onColorChange); //link to callback
            $('#hidePicker').click(e => {
              $('#colorpicker').toggle("slow");
            })
            $('#unmarked').click(e => {
              var sessionId = $(".temp_information2")[0].dataset["sessionId"];
              $.ajax({
                type: "POST",
                url: "/marks/find_unmarked",
                data: {session_id: sessionId},
                success: function(data){
                  if(!data['response']){
                    for(var j = 0; j < allSessionImages.length;j++){
                      if(allSessionImages[j].id == data['attachmentId']){
                        numberOfCurrentPage = j; 
                        img = $('#imgContent');
                        var imageOriginal = $('#imgContentBig');
                        img[0].src = allSessionImages[numberOfCurrentPage].image.url;
                        imageOriginal[0].src = allSessionImages[numberOfCurrentPage].image.url
                                      
                        deletePoints();
                        loadPoints(1, data['pointId']);
                        loadModalPoints();
                        addEventListenersForPoints();
                      }
                    }
                  } else {
                    alert(data['response'])
                  }
                },
                error: function() {
                  alert("All points were marked");
                }
              });
            })
        
            function onColorChange(color) {
              points = $(".myPoint");
              modalPoints = $(".myModalPoint");
              startingPointsColor = color;
              for(var i = 0; i < points.length;i++){
                var pointsChildren = points[i].children;
                for(var j = 0;j < pointsChildren.length;j++){
                  pointsChildren[j].style['background-color'] = color;
                }
              }
              for(var i = 0; i < modalPoints.length;i++){
                var pointsChildren = modalPoints[i].children;
                for(var j = 0;j < pointsChildren.length;j++){
                  pointsChildren[j].style['background-color'] = color;
                }
              }
            }
        
            function loadModalPoints(){
              var imgContainer = $('#imageContainerModal');
              for(var z = 0; z < pointsArray[numberOfCurrentPage].length; z++){
                var x = pointsArray[numberOfCurrentPage][z].x*allSessionImages[numberOfCurrentPage].image_width;
                var y = pointsArray[numberOfCurrentPage][z].y*allSessionImages[numberOfCurrentPage].image_height;
        
                var div = document.createElement("div");
                div.style.zIndex = 2000;
                div.className = "myModalPoint";
                div.style.top = (y-15) + 'px' ;
                div.style.left = (x-15) + 'px' ;
                var x_div = document.createElement("div");
                x_div.className = "x_div";
                var y_div = document.createElement("div");
                y_div.className = "y_div";
                div.appendChild(x_div);
                div.appendChild(y_div);
                x_div.style["background-color"] = startingPointsColor;
                y_div.style["background-color"] = startingPointsColor
                if(isSinglePoint){        
                  x_div.style.width = allSessionImages[numberOfCurrentPage].image_width + "px";
                  y_div.style.height = allSessionImages[numberOfCurrentPage].image_height + "px";
                  x_div.style.left = -(x-15) + 'px';
                  y_div.style.top = -(y-15) + 'px';
                  
                }
                imgContainer[0].appendChild(div);
              }
            }
        
            $(".openModal").click(e => {
              $(".bg-modal")[0].style.display = 'flex';
            })
            $("#close").click(e => {
              $(".bg-modal")[0].style.display = 'none';
            })
        
            $('.isHidden').click(e => {
              var points = $('.myPoint');
              if(hide){
                for(var i = 0; i < points.length;i++){
                  e.target.innerText = "Hide Points";
                  points[i].style.display = 'block';
                  hide = false;
                }
              } else {
                for(var i = 0; i < points.length;i++){
                  e.target.innerText = "Show Points";
                  points[i].style.display = 'none';
                  hide = true;
                }
              }
            })
        
        
            var allSessionImages = $('.temp_information').data("sessionAttachments");
            var next = $('.next');
            var prev = $('.prev');
            var numberOfCurrentPage = 0;
            var pts = $('.attachment');
            var pointsArray = [];
            var checkboxes = JSON.parse($('.attachment2')[0].dataset["sCheckboxes"]);
            loadCheckboxes();
            addEventListenersToCheckboxes()
            
            for(var x = 0; x < pts.length;x++){
              pointsArray.push(JSON.parse(pts[x].dataset["sPoints"]));
            }
            loadPoints(0);
            addEventListenersForPoints();
            $('.finish').click(e => {
              var userId = $(".currentId")[0].dataset["currentId"];
              
              var sessionId = $(".temp_information2")[0].dataset["sessionId"];
              $.ajax({
                type: "POST",
                url: "/session_statuses/finish_session",
                data: {user_id: userId, session_id: sessionId},
                success: function(msg) {
                  location.href = "/";
                },
                error: function(msg) {
                  alert("You didn't mark all points");
                }
              });
            })
        
            next.click(e =>{
              if(numberOfCurrentPage < allSessionImages.length - 1){
                img = $('#imgContent');
                var imageOriginal = $('#imgContentBig');
                img[0].src = allSessionImages[numberOfCurrentPage+1].image.url;
                imageOriginal[0].src = allSessionImages[numberOfCurrentPage+1].image.url
                numberOfCurrentPage++;
                deletePoints();
                loadPoints(0);
                loadModalPoints();
                addEventListenersForPoints();
              }
            })
            prev.click(e =>{
              if(numberOfCurrentPage > 0){
                img = $('#imgContent');
                var imageOriginal = $('#imgContentBig');
                img[0].src = allSessionImages[numberOfCurrentPage-1].image.url;
                imageOriginal[0].src = allSessionImages[numberOfCurrentPage-1].image.url
                numberOfCurrentPage--;
                currentId = allSessionImages[numberOfCurrentPage].id;;
                deletePoints();
                loadPoints(0);
                loadModalPoints();
                addEventListenersForPoints();
              }
            })
            function deletePoints(){
              $('.myPoint').remove();  
              $('.myModalPoint').remove(); 
            }
            function loadPoints(wasSearched, optArg){
        
              var imgContainer = $('#imageContainer');
              var imgContent = $('#imgContent');
        
              for(var z = 0; z < pointsArray[numberOfCurrentPage].length; z++){
        
                var x = pointsArray[numberOfCurrentPage][z].x*imgContent[0].width;
                var y = pointsArray[numberOfCurrentPage][z].y*imgContent[0].height;
                var div = document.createElement("div");
                var x_div = document.createElement("div");
                x_div.className = "x_div";
                var y_div = document.createElement("div");
                y_div.className = "y_div";
                div.appendChild(x_div);
                div.appendChild(y_div);
                div.className = "myPoint";
                div.style.top = (y-15) + 'px' ;
                div.style.left = (x-15) + 'px' ;
                div.dataset["id"] = pointsArray[numberOfCurrentPage][z].id;
                x_div.style["background-color"] = startingPointsColor;
                y_div.style["background-color"] = startingPointsColor;
                if(!isSinglePoint){
                  div.style.top = (y-15) + 'px' ;
                  div.style.left = (x-15) + 'px' ;
                } else {
                  div.style.top = (y-15) + 'px' ;
                  div.style.left = (x-15) + 'px' ;
                  x_div.style.width = imgContent[0].width + "px";
                  y_div.style.height = imgContent[0].height + "px";
                  x_div.style.left = -(x-15) + 'px';
                  y_div.style.top = -(y-15) + 'px';
                }
                imgContainer[0].appendChild(div);
                if(wasSearched == 0){
                  if(z == 0 ){
                    div.classList.add("active");
                    var currentId = $('.currentId')[0].dataset['currentId'];
                    var currentActive = $('.active')[0].dataset.id;
                    checkIfMarkExists();
                  }
                } 
              }
              if(wasSearched == 1){
                for(var k = 0; k < pointsArray[numberOfCurrentPage].length; k++){
                  if(pointsArray[numberOfCurrentPage][k].id == optArg){
                    var myPoints = $('.myPoint');
                    for(var l = 0; l < myPoints.length;l++){
                      myPoints[l].classList.remove("active");
                      var pointChildren = myPoints[l].children;
                      for(var j = 0; j < pointChildren.length;j++){
                        pointChildren[j].style["background-color"] = "red";
                      }
                    }                
                    var proper_div = $("div[data-id='"  + optArg  +"']");
                    proper_div[0].classList.add("active");
                    var pointChildren = proper_div[0].children;
                    var currentId = $('.currentId')[0].dataset['currentId'];
                    var currentActive = $('.active')[0].dataset.id;
                    checkIfMarkExists();
                    }
                  }
              } 
            }
        
            function addEventListenersForPoints(){
              var myPoints = $('.myPoint');
              for(var i = 0; i< myPoints.length;i++){
                myPoints[i].addEventListener("click",e => {
                  for(var i = 0; i < myPoints.length;i++){
                    myPoints[i].classList.remove("active");
                  };
                  e.target.classList.add("active");
                  var children = e.target.children;
                  /*for(var j = 0; j < children.length;j++){
                    children[j].style["background-color"] = "green";
                  }*/
                  
        
                  
                  //var choosenValue = $('.choosen')[0].value;
                  //var currentId = $('.currentId')[0].dataset['currentId'];
                  //var currentActive = $('.active')[0].dataset.id;
        
                  checkIfMarkExists();  
                });
              }
            }
            function addEventListenersToCheckboxes(){
              var checkboxes = $('.optionCheckbox');
              for(var i = 0; i < checkboxes.length; i++){
                checkboxes[i].addEventListener("click",event =>{
                  for(var i = 0; i < checkboxes.length; i++){
                    checkboxes[i].checked = false;
                    checkboxes[i].classList.remove("choosen");
                  }
                  event.target.checked = true;
                  event.target.classList.add("choosen"); 
                  var choosenValue = $('.choosen')[0].value;
                  var currentId = $('.currentId')[0].dataset['currentId'];
                  var currentActive = $('.active')[0].dataset.id;
                  var sessionId = $(".temp_information2")[0].dataset["sessionId"];
                  $.ajax({
                    type: "POST",
                    url: "/marks/createOrUpdate",
                    data: {choosenValue : choosenValue, currentId : currentId, currentActive : currentActive,session_id : sessionId},
                    success: function(msg){
                      console.log( "Data Saved: " + msg );
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                      console.log("some error");
                    }
                  });
                  for(var i = 0; i < checkboxes.length; i++){
                    checkboxes[i].checked = false;
                    checkboxes[i].classList.remove("choosen");
                  }
                  event.target.checked = true;
                  event.target.classList.add("choosen");         
                })
              }
            }
            function checkIfMarkExists(){
              var currentActive = $('.active')[0].dataset.id;
              $.ajax({
                type: "POST",
                url: "/points/find_mark",
                data: {current_point: currentActive},
                success: function(data){
                  var checkboxes = $('.optionCheckbox');
                  if(data['found'] == 1){
                    var x = document.querySelectorAll(`input[value="${data['res']}"]`);         
                    for(var i = 0; i < checkboxes.length; i++){
                      checkboxes[i].checked = false;
                      checkboxes[i].classList.remove("choosen");
                    }
                    x[0].checked = true;
                    x[0].classList.add('choosen');
        
                  var choosenValue = $('.choosen')[0].value;
                  var currentId = $('.currentId')[0].dataset['currentId'];
                  var currentActive = $('.active')[0].dataset.id;
                  } else {
                    for(var i = 0; i < checkboxes.length; i++){
                      checkboxes[i].checked = false;
                      checkboxes[i].classList.remove("choosen");
                    }
        
                  }
                }
              });
            }
        
            function loadCheckboxes(){
              checkboxes.forEach(chBox => {
                var x = 0
                var checkboxDiv = document.createElement("label");
                checkboxDiv.className = "checkboxHolder"; 
                var checkbox = document.createElement("input");
                checkboxDiv.innerText = " " + chBox.description + " ";
                checkbox.type = "checkbox";
                checkbox.className = "optionCheckbox"
                checkbox.value = chBox.description;
            
                checkboxDiv.appendChild(checkbox);
        
                $('#checkboxes')[0].appendChild(checkboxDiv);
              })
            }
            loadModalPoints();
          })
    }
})();