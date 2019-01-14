# Otaku

A simple jwt based image upload server that works off bunny CDN

![](https://pm1.narvii.com/5824/13b53b8e3e490c86d1963e9648e2bf6a949a8e0c_hq.jpg)


## Building for development

1. `mix deps.get`
2. `ies -S `

## Building for production

1. `docker build otaku .`
2. `docker run -it -p 4000:4000 --name otaku -e OTAKU_ACCESS_KEY=<your_access_key_here> -e OTAKU_STORAGE=<storage_name_here> otaku`

<hr>

### Processing requests

#### /upload
* **Headers** 
    * Authorization="Bearer $YOUR_GOOGLE_SIGNED_JWT"
    * Content-Type="multipart/form-data"
* **Form-Data**
    * image: file binary

* **Response**: { "url": "$OTAKU_CDN_URL/$USER_ID/$IMAGE_NAME" }
