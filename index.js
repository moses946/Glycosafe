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