// carousel code
document.addEventListener("DOMContentLoaded", ()=>{
    var icons = document.querySelectorAll(".question__top img");
    var hidden_answers = document.querySelectorAll(".question__bottom");
    console.log(icons);
    for(let i = 0; i<icons.length;i++ ){
        icons[i].addEventListener("click", ()=>{
            if(hidden_answers[i].classList.contains("opened")){
                icons[i].src = "assets/images/icon-plus.svg";
                hidden_answers[i].classList.toggle("opened");
            }else{
                icons[i].src="assets/images/icon-minus.svg"
                hidden_answers[i].classList.toggle("opened");
            }
           
        })
    }
  })