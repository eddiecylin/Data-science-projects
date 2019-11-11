
# Project description: 
This project uses customer data from a telecommunication company and intends to build a machine learning model to predict customer churn. Using different demographic and behavioral features about the customers in this dataset, the goals of is project are: (1) build and optimize a classification model that can predict customer churn and (2) identify important features in the dataset for marketing, operation, and customer relationship team to design their action plans to maximize customer retention.

The following will be a presentation of the key findings in this project 

## Data source & feature overview:
The dataset was downloaded from Kaggle. Excluding customer ID, there are 19 features which will be used as predictors and 1 target variable (customer churn). Here is the list for feature definitions.

![overview of features](https://github.com/eddiecylin/data-science-projects/blob/master/Telcom-churn-prediction/images/variables.png)

## Check data integrity:
Before data modeling, we will first check the missing values and outliers

Using heatmap, it shows that there is a small number of missing values existing in the `TotalCharges` column. Using a simple line of code `df.isnull().sum()`, it confirms that there are 11 missing values in that column. Since it is relatively a small number, we could keep data rows which don’t contain missing values in this column.

![missing values](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/missing%20values%20viz.png)

Next, we will look at the summary table to detect outliers and correlation plot for continuous features. By looking at the maximum and minimum for the continuous features, it shows that there are no significant outliers. 

![data summary table](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/outliers%20.png)

By observing the correlation plot, the only obvious correlation is between tenure and total charge. This makes intuitive sense as the longer you stay in the company's service, the more in total you spend. What's of note is that monthly charge and total charge are modestly correlated (r=.65). This suggests that for long tenure customers, their monthly payment may not be high although it is possible.

![correlation plot](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/correlation.png)

## Exploratory data visualization: 

Before a series of modeling, it is useful to get an initial perception of some important features in relation to customer churn. One practical approach will be observe the pattern of different features after subsetting them into  `churn` or  `no churn` categories. Here are a few interesting findings:

![contract](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/contract.png)

![internet service](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/internet%20service.png)

![online backup](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/online%20backup.png)

![online backup](https://github.com/eddiecylin/Data-science-projects/blob/master/Telcom-churn-prediction/images/partner%20.png)







[See full project notebook](https://github.com/eddiecylin/data-science-projects/blob/master/Telcom-churn-prediction/Telco_churn_prediction.ipynb)    
[See notebook to host model on AWS SageMaker](https://github.com/eddiecylin/data-science-projects/blob/master/Telcom-churn-prediction/Telco_churn_prediction(SageMaker).ipynb)
