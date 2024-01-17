import "./decidim_newsletter_agenda.scss";

// Images
require.context("../images", true)
require.context("../fonts", true)


document.addEventListener('DOMContentLoaded', function () {
  
    const accordionItems = document.querySelectorAll('.accordion-item');
    console.log("hola");
    accordionItems.forEach(function (item) {

      const title = item.querySelector('.accordion-title');
      let content = item.querySelector('.accordion-content');
      console.log(content.style.display);
      content.style.display = 'none';

      title.addEventListener('click', function () {

        content = item.querySelector('.accordion-content');
        content.style.display = content.style.display === 'none' ? 'block' : 'none';
      });
    });
});
