# Parameter initialization

gap_time = 1  # gap time between each segment
# win_size = [1,1,1]  # window size of each segment
win_size = [1]  # window size of each segment
step_max = 3 # maximum step of ConvLSTM

raw_data_path = '../data/synthetic_data_with_anomaly-s-1.csv'  # path to load raw data
model_path = '../MSCRED/'
train_data_path = "../data/train/"
test_data_path = "../data/test/"
reconstructed_data_path = "../data/reconstructed/"


train_start_id = 0
train_end_id = 11999

test_start_id = 0
test_end_id = 11999

valid_start_id = 300
valid_end_id = 400

training_iters = 1
# save_model_step = 1

learning_rate = 0.003

threhold = 1
alpha = 0.01