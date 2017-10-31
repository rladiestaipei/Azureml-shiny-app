
def azureml_main(dataframe1 = None, dataframe2 = None):
    import pickle
    import numpy as np
    import pandas as pd
    pickled_data = dataframe1.ix[0,0]
    clf = pickle.loads(pickled_data)
    print clf
    features = np.array(dataframe2.ix[:,1:])
    predicted_labels = clf.predict(features)
    predicted_probs = pd.DataFrame(clf.predict_proba(features), columns = ['Probability for Class ' + str(c) for c in clf.classes_])
    print predicted_probs
    
    dataframe2["Predicted Labels"] = predicted_labels
    dataframe2 = pd.concat([dataframe2, predicted_probs], axis=1)    
    return dataframe2,
