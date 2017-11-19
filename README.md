# Azureml-shiny-app
Titanic prediction workshop - shiny on Azure via ML studio

學習如何用鐵達尼號數據做出一個web service，上手Machine Learning Studio 以 Web 服務方式發佈模型，透過R Shiny做出可互動式預測結果並在 Azure 虛擬機器執行

課程內容分成三部分
1. Azure Machine Learning Studio介紹
2. 連結預設模型(AzureML裡)到Shiny
3. 如何用Python在Azure ML刻演算法

![圖](https://www.evernote.com/l/ANzHJ9AEGuBJ76lgy3taL1uELsbMe353i28B/image.png)



每個部分會包含 Code/示範、教學文件、補充教材

## Azure Machine Learning Studio介紹 @Ning
### Code/示範
[link](https://gallery.cortanaintelligence.com/Experiment/AzureMLPredictModelforteaching)

### 教學文件
[slide](https://www.slideshare.net/secret/zUakvy1Om1mfLW)
[官方文件](https://docs.microsoft.com/en-us/azure/machine-learning/studio/what-is-ml-studio)

### 補充教材
AzureML環境介紹 [Video](https://www.facebook.com/chiehningchen/videos/10154231877932471/)
如何上傳資料 [Video](https://www.facebook.com/chiehningchen/videos/10154322903962471/)
五分鐘快速上手 [link](https://docs.microsoft.com/en-us/azure/machine-learning/preview/)


## 連結預設模型(AzureML裡)到Shiny @Kristen
### Code/示範
[link](https://github.com/rladiestaipei/Azureml-shiny-app/)

### 教學文件
[slide](https://www.slideshare.net/HsinYuChan1/shiny-on-azure)

### 補充教材
+ [Request Response API Documentation for TitanicWS](https://studio.azureml.net/apihelp/workspaces/852a506a05ab41868939caa8f97d3a57/webservices/cc53c7743e5b4abbbeb417fa807c4fbc/endpoints/c052c781636540b4a2530c5b753cb947/score#sampleCode)
+ [Shiny Cheat sheet](https://shiny.rstudio.com/articles/cheatsheet.html)

### Docker 版本使用方式
開啟 `terminal` 或是 `power shell` 執行

```
docker version
docker pull kristenchan/azureml_shiny
cd ${PROJ_DIR}
git clone https://github.com/rladiestaipei/Azureml-shiny-app.git

# 更新 API Key，do whatever you wanna deal with your shiny app

docker run --rm --name rladies_azureml -p 3838:3838 \
    -v ${PROJ_DIR}/Azureml-shiny-app/:/srv/shiny-server/ \
    -v ${PROJ_DIR}/Azureml-shiny-app/log/:/var/log/shiny-server/ \
    rocker/shiny
docker exec -d rladies_azureml sh /srv/shiny-server/prepare_library.sh

# 這中間要等一下大概三到五分鐘讓 Docker 裡面把 library 裝起來

docker restart rladies_azureml
```

打開瀏覽器，網址列輸入 `localhost:3838/Shiny_Titanic`

## 如何用Python在Azure ML刻演算法 @Mia

### Code/示範
[link](https://github.com/rladiestaipei/Azureml-shiny-app/tree/master/python)
### 教學文件

### 補充教材
參考資料1.Training and operationalization of Scikit-Learn models
https://gallery.cortanaintelligence.com/Experiment/Training-and-operationalization-of-Scikit-Learn-models-1

