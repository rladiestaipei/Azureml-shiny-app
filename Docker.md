# Docker 版本使用方式

開啟 terminal 或是 power shell 執行

docker version
docker pull kristenchan/azureml_shiny
cd ${PROJ_DIR}
git clone https://github.com/rladiestaipei/Azureml-shiny-app.git

# 更新 API Key，do whatever you wanna deal with your shiny app

```
docker run --rm --name rladies_azureml -p 3838:3838 \
    -v ${PROJ_DIR}/Azureml-shiny-app/:/srv/shiny-server/ \
    -v ${PROJ_DIR}/Azureml-shiny-app/log/:/var/log/shiny-server/ \
    rocker/shiny
docker exec -d rladies_azureml sh /srv/shiny-server/prepare_library.sh
```

# 這中間要等一下大概三到五分鐘讓 Docker 裡面把 library 裝起來

docker restart rladies_azureml
打開瀏覽器，網址列輸入 localhost:3838/Shiny_Titanic
