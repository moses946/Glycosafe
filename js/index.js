document.querySelector('.burger-menu').addEventListener('click', function() {
    this.classList.toggle('open');
  });
  
  const activePage = window.location.pathname;
  const navLinks = document.querySelectorAll('.menu').forEach(link => {
    if(link.href.includes(`${activePage}`)){
      link.classList.add('active');
      console.log(link);
    }
  })


  
  let initSlider = ()=>{
    const imageList = document.querySelector(".illustration .illustration__carousel");
    const slideButtons = document.querySelectorAll(".carousel-control");
    const maxScrollLeft = imageList.scrollWidth ;

    slideButtons.forEach(button=>{
        button.addEventListener("click", ()=>{
            const direction = button.id=="prev-btn"? -1: 1;
            const scrollAmount = imageList.clientWidth * direction

            imageList.scrollBy({
                left: scrollAmount,
                behavior: 'smooth'
            });

        })
    })

    const handleSlideBtns = ()=>{
        slideButtons[0].style.display = imageList.scrollLeft <=0 ? "none": "block";
        slideButtons[1].style.display = imageList.scrollLeft >= maxScrollLeft ? "none":"block";
    }

    imageList.addEventListener("scroll", ()=>{
        handleSlideBtns()
    })
}

window.addEventListener("DOMContentLoaded", initSlider);

const handleAppBtn = ()=>{
    window.alert("The app is currently only available to red teamers for testing...")
}

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