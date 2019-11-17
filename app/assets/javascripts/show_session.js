window.ShowSession = (function(){
    return {
        run:run
    }
   
    function run(page){  $(document).ready( () => {
    var allSessionImages = $('.temp_information').data("sessionAttachments")//$('.temp_information').data('session_attachments');
    var sessionId = $('.temp_information2').data("sessionId");
    var isSinglePoint = $('.is_session_single_point').data("singlePoint");
    var isUploaded = $('.is_session_uploaded').data("isUploaded");
    //console.log(session);
    var array = [];
    var pts = $('.attachment');
    var hide = false;
    var isDeleting = false;

    var next = $('.next');
    var prev = $('.prev');
    var addCheckbox = $('.addCheckbox');
            
            



    var numberOfCurrentPage = page;//#{params[:current_page].try(:to_i) || 0};
    var currentId = allSessionImages[numberOfCurrentPage].id;
    var checkboxes = JSON.parse($('.attachment2')[0].dataset["sCheckboxes"]);
    var checkboxesLength = checkboxes.length;
    for(var x = 0; x < pts.length;x++){
      array.push(JSON.parse(pts[x].dataset["sPoints"]))
    }

    var img2 = $('#imgContent');
    var imageOriginal = $('#imgContentBig');
    img2[0].src = allSessionImages[numberOfCurrentPage].image.url;
    imageOriginal[0].src = allSessionImages[numberOfCurrentPage].image.url


    $('.deleteSelected').click(e => {
      var checkbox = $('.choosen');
      var checkboxText = $('.choosen').val();
      if(checkboxText != undefined){
        $.ajax({
          type: "POST",
          url: "/checkboxs/remove",
          data: {session_id: sessionId, checkbox_text: checkboxText},
          success: function(){
            checkboxesLength--; 
          }
        });
      }
      checkbox.parent().remove();    
    })
    $('.deleteSelectedPoint').click(e => {
      if(isDeleting){
        e.target.innerText = "Delete Points"
        isDeleting = false;
      } else {
        e.target.innerText = "Add Points"
        isDeleting = true;
      }
    })
    $('.uploadSession').click(e => {
      if(confirm("Are you sure your session is ready to be uploaded?")){ 
        if(checkboxesLength != 0){      
          $.ajax({
            type: "POST",
            url: "/photo_sessions/upload_session",
            data: {session_id: sessionId},
            success: function(msg){
              alert("Your session have been uploaded!");
              reloadPage();
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
              alert(msg['error']);
            }
          });
        } else {
          alert("Add at least one option!");
        }
      }
    })



    $('.hidePoints').click(e => {
      var points = $('.myPoint');
      var modalPoints = $('.myModalPoint');
      if(hide){
        for(var i = 0; i < points.length;i++){
          e.target.innerText = "Hide Points";
          points[i].style.display = 'block';
          modalPoints[i].style.display = 'block'
          hide = false;
        }
      } else {  
        for(var i = 0; i < points.length;i++){
          e.target.innerText = "Show Points";
          points[i].style.display = 'none';
          modalPoints[i].style.display = 'none';
          hide = true;
        }
      }
    })

    $("#modalCheckboxes")[0];
    $(".openModal").click(e => {
      $(".bg-modal")[0].style.display = 'flex';
    })
    $("#close").click(e => {
      $(".bg-modal")[0].style.display = 'none';
    })
    
    

    function loadModalPoints(){
      var imgContainer = $('#imageContainerModal');

      for(var z = 0; z < array[numberOfCurrentPage].length; z++){
        var x = array[numberOfCurrentPage][z].x*allSessionImages[numberOfCurrentPage].image_width;
        var y = array[numberOfCurrentPage][z].y*allSessionImages[numberOfCurrentPage].image_height;

        var div = document.createElement("div");
        div.style.zIndex = 2000;
        div.className = "myModalPoint";
        div.style.top = (y-15) + 'px' ;
        div.style.left = (x-15) + 'px' ;
        div.dataset["id"] = array[numberOfCurrentPage][z].id;
        var x_div = document.createElement("div");
        x_div.className = "x_div";
        var y_div = document.createElement("div");
        y_div.className = "y_div";
        x_div.style["background-color"] = "red";
        y_div.style["background-color"] = "red";
        div.appendChild(x_div);
        div.appendChild(y_div);
        if(isSinglePoint){        
          x_div.style.width = allSessionImages[numberOfCurrentPage].image_width + "px";
          y_div.style.height = allSessionImages[numberOfCurrentPage].image_height + "px";
          x_div.style.left = -(x-15) + 'px';
          y_div.style.top = -(y-15) + 'px';
        }
        imgContainer[0].appendChild(div);
      }
    }
    function loadPoints(){
      var imgContainer = $('#imageContainer');
      var imgContent = $('#imgContent');


      for(var z = 0; z < array[numberOfCurrentPage].length; z++){
        var x = array[numberOfCurrentPage][z].x*imgContent[0].width;
        var y = array[numberOfCurrentPage][z].y*imgContent[0].height;

        var div = document.createElement("div");
        var x_div = document.createElement("div");
        x_div.className = "x_div";
        var y_div = document.createElement("div");
        y_div.className = "y_div";
        div.appendChild(x_div);
        div.appendChild(y_div);
        div.className = "myPoint";
        x_div.style["background-color"] = "red";
        y_div.style["background-color"] = "red";
        div.dataset["id"] = array[numberOfCurrentPage][z].id;
        if(!isSinglePoint){
          div.style.top = (y-15) + 'px' ;
          div.style.left = (x-15) + 'px' ;
        } else {
          x_div.style.width = imgContent[0].width + "px";
          y_div.style.height = imgContent[0].height + "px";
          div.style.top = (y-15) + 'px' ;
          div.style.left = (x-15) + 'px' ;
          x_div.style.left = -(x-15) + 'px';
          y_div.style.top = -(y-15) + 'px';
        }
        imgContainer[0].appendChild(div);
      }
    }
    function deletePoints(){
      $('.myPoint').remove(); 
      $('.myModalPoint').remove(); 
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
        })
      }
    }

    function loadCheckboxes(checkboxesHolderId){
      checkboxes.forEach(chBox => {
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


    
    img = $('#imgContent');
    loadCheckboxes('#checkboxes');
    addCheckbox.click(e => {
      if(!($('.checkboxText')[0].value == "")){
        var checkboxDiv = document.createElement("label");
        checkboxDiv.className = "checkboxHolder"
        var checkbox = document.createElement("input");

        var text = $('.checkboxText');
        checkboxDiv.innerText = text[0].value;
        checkbox.type = "checkbox";
        checkbox.className = "optionCheckbox"
        checkbox.value = text[0].value;

        checkboxDiv.appendChild(checkbox);
        $('#checkboxes')[0].appendChild(checkboxDiv);

        $.ajax({
          type: "POST",
          url: "/checkboxs",
          data: {checkbox_text: text[0].value,session_id: sessionId },
        });
        text[0].value = "";
        addEventListenersToCheckboxes();
        checkboxesLength++;

      } else {
        alert("You can't add empty option");
      }

    })
    if(!isSinglePoint && !isUploaded){
      img.click(e => {
        if(!isDeleting){
          var x = e.offsetX; 
          var y = e.offsetY;
          var scaleX = x/e.target.width;
          var scaleY = y/e.target.height;
          alert("X Coordinate: " + x + " Y Coordinate: " + y);

          $.ajax({
            type: "POST",
            url: "/points",
            data: {scale_x: scaleX,scale_y: scaleY, sessionAttachmentId : currentId },
          });

          reloadPage();
        }         
      })
    }
    next.click(e =>{
      if(numberOfCurrentPage < allSessionImages.length - 1){

        img = $('#imgContent');
        var imageOriginal = $('#imgContentBig');
        img[0].src = allSessionImages[numberOfCurrentPage+1].image.url;
        imageOriginal[0].src = allSessionImages[numberOfCurrentPage+1].image.url
        numberOfCurrentPage++;
        console.log(numberOfCurrentPage);
        currentId = allSessionImages[numberOfCurrentPage].id;
        deletePoints();
        loadModalPoints();
        loadPoints();
        if(!isUploaded){
          addEventListenersToDeletePoints();
        }
      }
    })
    prev.click(e =>{
      if(numberOfCurrentPage > 0){
        if(numberOfCurrentPage == allSessionImages.length -1){
          $('.endButton').remove();
        }
        img = $('#imgContent');
        img[0].src = allSessionImages[numberOfCurrentPage-1].image.url;
        numberOfCurrentPage--;
        currentId = allSessionImages[numberOfCurrentPage].id;;
        deletePoints();
        loadModalPoints();
        loadPoints();
        if(!isUploaded){
          addEventListenersToDeletePoints();
        }
      }
    })
    function addEventListenersToDeletePoints(){
      var allPoints = $('.myPoint');
      for(var j = 0; j < allPoints.length;j++){
        allPoints[j].addEventListener("click",event => {
           if(isDeleting){
            var pointId = event.target.dataset.id;
            for(var k = 0; k < array[numberOfCurrentPage].length;k++){
              if(array[numberOfCurrentPage][k].id == pointId){
                array[numberOfCurrentPage].splice(k,1);
              }
            }
            $.ajax({
              type: "POST",
              url: "/points/remove",
              data: {point_id: pointId},
            });
            event.target.remove();
          }
        })
      }
    }

    loadModalPoints();
    loadPoints();
    addEventListenersToCheckboxes();
    if(!isUploaded){
      addEventListenersToDeletePoints();
    }
    function reloadPage() {
      history.replaceState({}, document.title, "?current_page=" + numberOfCurrentPage);
      location.reload();
    }
  })
  

}
})();