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
