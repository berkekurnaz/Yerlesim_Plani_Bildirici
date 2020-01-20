const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");

const { createWorker } = require("tesseract.js");

var http = require('http').createServer(express);
var io = require('socket.io')(http);

var creatorImageName = require("./helper/creatorImageName");
var myImageHelper = require("./helper/myImageHelper");
const multer = require('multer');
var storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, './public/folderImages');
    },
    filename: (req, file, cb) => {
        console.log(file);
        var filetype = '';
        if (file.mimetype === 'image/gif') {
            filetype = 'gif';
        }
        if (file.mimetype === 'image/png') {
            filetype = 'png';
        }
        if (file.mimetype === 'image/jpeg') {
            filetype = 'jpg';
        }
        cb(null, 'image-' + creatorImageName.generateImage() + '.' + filetype);
    }
});
var upload = multer({ storage: storage });

const app = express();

app.use(express.static(path.join(__dirname, "public")));
app.use(bodyParser.json());

var cors = require("cors");
app.use(cors());

class Ogrenci {

    constructor(ad, sinif, koltuk) {
        this.ad = ad;
        this.sinif = sinif;
        this.koltuk = koltuk;
    }

}

app.post("/ocr", upload.single('file'), (req, res) => {

    var myFileName = "";
    if (!req.file) {
        myFileName = "http://localhost:5000/folderImages/defaultimage.png";
    } else {
        myFileName = 'http://localhost:5000/folderImages/' + req.file.filename;
    }

    const worker = createWorker({
        logger: m => console.log(m)
    });

    var resultText = "";

    (async () => {
        await worker.load();
        await worker.loadLanguage('tur');
        await worker.initialize('tur');
        const { data: { text } } = await worker.recognize(myFileName);
        resultText = text;
        await worker.terminate();
    })().then(()=> {
        return res.json(resultText);
    });

});

app.post("/test", upload.single('file'), (req, res) => {

    console.log("Start Program");

    var myFileName = "";
    if (!req.file) {
        myFileName = "http://localhost:5000/folderImages/defaultimage.png";
    } else {
        myFileName = 'http://localhost:5000/folderImages/' + req.file.filename;
    }

    const worker = createWorker({
        logger: m => console.log(m)
    });

    var ogrenciler = [];

    var resultText = "";

    (async () => {
        await worker.load();
        await worker.loadLanguage('tur');
        await worker.initialize('tur');
        const { data: { text } } = await worker.recognize(myFileName);
        console.log(text);
        resultText = text;
        await worker.terminate();
    })().then(() => {

        var ogrenci = "";
        var sinif = "";
        var koltuk = "";

        console.log("Program Yapısı");
        var result = resultText.split("\n")
        console.log(result);
        result.forEach((item) => {
            console.log("Program DÖNGÜSÜ");
            if (item.length > 10) {
                console.log(item);
                var parcaliString = item.split(" ");
                ogrenci = parcaliString[2];
                sinif = parcaliString[4];
                koltuk = parcaliString[5];
                var eklenecekOgrenci = new Ogrenci(ogrenci, sinif, koltuk);
                ogrenciler.push(eklenecekOgrenci)
            }
        });

        console.log("Öğrenci Adı : " + ogrenci);
        console.log("Öğrenci Sınıfı : " + sinif);
        console.log("Öğrenci Koltuk : " + koltuk);

        console.log("************************************************");
        ogrenciler.forEach(element => {
            console.log("ÖĞRENCİ KOLTUK BİLGİLERİ\n*************************");
            console.log("Öğrenci Adı : " + element.ad);
            console.log("Öğrenci Sınıfı : " + element.sinif);
            console.log("Öğrenci Koltuk : " + element.koltuk);
        });
    }).then(() => {
        io.emit('students list', ogrenciler);
        return res.json(ogrenciler);
    });

    console.log("End Program");
});

const port = 5000;

io.on('connection', function(socket){
    console.log('user connected');



    socket.on('disconnect', function(){
      console.log('user disconnected');
    });
});

app.listen(port, () => console.log(`Server started on port ${port}`));




