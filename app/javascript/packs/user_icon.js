if (document.URL.match( /new/ ) || document.URL.match( /edit/ )){
  document.addEventListener('DOMContentLoaded', function() {
    const ImageList = document.getElementById('image-list');
    const userImage = document.getElementById('user_image');
    const blobImage = document.createElement('img');

    const createImageHTML = (blob) => {

      blobImage.setAttribute('src', blob);
      blobImage.setAttribute('class', 'preview-usericon');

      ImageList.appendChild(blobImage);
    }

    userImage.addEventListener('change', (e) =>{
      const imageContent = document.querySelector('img');
      if(imageContent){
        blobImage.remove();
      }

      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);

      createImageHTML(blob);
    })

  });
} 