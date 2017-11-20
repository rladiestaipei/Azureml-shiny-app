# Docker 版本使用方式

** Step0. **
先安裝好 Docker
> Docker For Mac / Docker For Windows

** Step1. **
開啟 Terminal 或是 Power Shell 

** Step2. **
```
docker version
docker pull kristenchan/azureml_shiny
cd ${PROJ_DIR}
git clone https://github.com/rladiestaipei/Azureml-shiny-app.git
```
> Do whatever you wanna deal with your shiny app
> + 更新 API Key

** Step3. **
```
docker run --rm --name rladies_azureml -p 3838:3838 \
    -v ${PROJ_DIR}/Azureml-shiny-app/:/srv/shiny-server/ \
    -v ${PROJ_DIR}/Azureml-shiny-app/log/:/var/log/shiny-server/ \
    kristenchan/azureml_shiny
```
** Step4. **
打開瀏覽器，網址列輸入 localhost:3838/Shiny_Titanic
