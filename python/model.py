def azureml_main(dataframe1 = None, dataframe2 = None):
    import numpy as np
    import pandas as pd        
    import pickle    
    from sklearn.ensemble import RandomForestClassifier        
       
    clf = RandomForestClassifier(n_estimators=25)
    X_train = np.array(dataframe1.ix[:,2:])
    y_train = np.array(dataframe1.ix[:,1])
    clf.fit(X_train, y_train)    
    state = pickle.dumps(clf)
    ret = pd.DataFrame(data = [state], columns=["Serialized Model"])    
    return ret,
