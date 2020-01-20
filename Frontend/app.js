const input = document.querySelector("#fileInputArea");
const btnSend = document.querySelector("#btnSend");

const loading = document.querySelector("#loading");
const ogrenciler = document.querySelector("#ogrenciler");
const ogrenciarea = document.querySelector("#ogrenciarea");

btnSend.addEventListener('click', () => {
    uploadFile(input.files[0]);
});

loading.setAttribute('style','display:none');
ogrenciarea.setAttribute('style','display:none');
btnSend.setAttribute('style','display:block');

const uploadFile = (file) => {

    if(file != null){
        loading.setAttribute('style','display:block');
        btnSend.setAttribute('style','display:none');

        if (!['image/jpeg', 'image/gif', 'image/png', 'image/svg+xml'].includes(file.type)) {
            console.log('Only images are allowed.');
            return;
        }
    
        if (file.size > 2 * 1024 * 1024) {
            console.log('File must be less than 2MB.');
            return;
        }
    
        const fd = new FormData();
        fd.append('file', file);
    
        fetch('http://localhost:5000/test', {
            method: 'POST',
            body: fd
        })
            .then(res => res.json())
            .then(json => {
    
                ogrenciarea.setAttribute('style','display:block');
                var html = "";
                json.forEach(element => {
                    html += '<div class="col-md-4"><div class="card"><div class=card-body>' + element.ad + " " + element.sinif + " " + element.koltuk + '</div></div></div>'
                });
    
                ogrenciler.innerHTML = html;
                loading.setAttribute('style','display:none');
            })
            .catch(err => console.error(err));
    }else{
        alert("Resim Alanını Lutfen Doldurun");
    }
}