import os
import pandas as pd

#%%%%  Import the data and create a new data frame

path = "./Sales_Data"
files = [file for file in os.listdir(path) if not file.startswith('.')] # Ignore hidden files

all_months_data = pd.DataFrame()

for file in files:
    current_data = pd.read_csv(path+"/"+file)
    all_months_data = pd.concat([all_months_data, current_data])
    
all_months_data.to_csv("all_data.csv", index=False)

all_data = pd.read_csv("all_data.csv")
all_data.head()

#%% Missing values & Data Formatting

nan_df = all_data[all_data.isna().any(axis=1)]

all_data = all_data.dropna(how='all')
all_data.head()

all_data = all_data[all_data['Order Date'].str[0:2]!='Or']

all_data['Quantity Ordered'] = pd.to_numeric(all_data['Quantity Ordered'])
all_data['Price Each'] = pd.to_numeric(all_data['Price Each'])

all_data['Order Date'] =pd.to_datetime(all_data['Order Date'])

all_data['Month'] = pd.to_datetime(all_data['Order Date']).dt.month
all_data.head()

month_label = ['January', 'February', 'March',
               'April', 'May', 'June',
               'July', 'August', 'September', 
               'Ocrober', 'November', 'December']


def get_city(address):
    return address.split(",")[1].strip(" ")

def get_state(address):
    return address.split(",")[2].split(" ")[1]

all_data['City'] = all_data['Purchase Address'].apply(lambda x: f"{get_city(x)}  ({get_state(x)})")

#%%% exploratpry 

import seaborn as sns 
import matplotlib.pyplot as plt

montly_sales = sns.barplot()