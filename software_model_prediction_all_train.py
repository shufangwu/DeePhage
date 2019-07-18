from keras.models import load_model
import scipy.io as sio
import numpy as np
import sys
argc = len(sys.argv)

argv = sys.argv
name = argv[1]
output_name = argv[2]
file = sio.loadmat('temp_file/'+name)

test_matrix = file['test_matrix'][:].ravel()
reads_number = file['current_reads_number'][:].ravel()
size2 = file['size2'][:].ravel()

test_matrix = np.reshape(test_matrix,(int(reads_number),int(size2)))
test_matrix = np.array(test_matrix)

result = list()

model1 = load_model('100_400_all_train_model.h5')
model2 = load_model('400_800_all_train_model.h5')
model3 = load_model('800_1200_all_train_model.h5')
model4 = load_model('1200_1800_all_train_model.h5')

for i in range(int(reads_number)):
    result_pre = list()
    a_all = 0
    for j in range(int(size2)):
        test = test_matrix[i][j]
        if test != []:
            if len(test)<=400:
                model = model1
           
                preds = model.predict(np.reshape(test,(1,400,4)))
                a = 400
                a_all = a_all+400
            elif (400<len(test)) and (len(test)<=800):
                model = model2
                preds = model.predict(np.reshape(test, (1, 800, 4)))
                a = 800
                a_all = a_all + 800
            elif (800<len(test)) and (len(test)<=1200):
                model = model3
                preds = model.predict(np.reshape(test, (1, 1200, 4)))
                a = 1200
                a_all = a_all + 1200
            else:
                model = model4
                preds = model.predict(np.reshape(test, (1, 1800, 4)))
                a = 1800
                a_all = a_all + 1800

            result_pre.append(a*preds)

    result1 = np.sum(np.array(result_pre) / a_all)
    result.append(result1)
np.savetxt('temp_file/'+output_name,result)
