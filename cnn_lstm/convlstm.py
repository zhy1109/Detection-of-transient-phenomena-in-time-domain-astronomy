import tensorflow as tf
import sys
sys.path.append('/Users/yangyang/Downloads/MSCRED-master/cnn_lstm')
import utils as util
import numpy as np
import os
from mmd import MMD
import matplotlib.pyplot as plt
lambda1=1
lambda2=1
def cnn_encoder_layer(data, filter_layer, strides):
    """
    :param data: the input data, when it is the first layer is 5 * 30 * 30 * 3, the second layer is 30 * 30 * 32,
                 the third layer is 15 * 15 * 64, the fourth layer is 8 * 8 * 128
    :param filter_layer:
    :param strides:
    :return: the result after conv, the first layer is 30 * 30 * 32, the second layer is 15 * 15 * 64, the third layer
             is 8 * 8 * 128, the final layer is 4 * 4 * 256
    """
    result = tf.nn.conv2d(
        input=data,
        filters=filter_layer,
        strides=strides,
        padding="SAME")
    return tf.nn.selu(result)
# data size  [ batch, in_height, in_width, in_channel ]
# filter：卷积核 [ filter_height, filter_width, in_channel, out_channels]
# strides [ 1, strides, strides, 1]
def tensor_variable(shape, name):
    """
    Tensor variable declaration initialization
    :param shape:
    :param name:
    :return:
    """
    # variable = tf.Variable(tf.zeros(shape), name=name)
    variable = tf.compat.v1.get_variable(name, shape=shape, initializer=tf.keras.initializers.glorot_normal)#initializer=tf.contrib.layers.xavier_initializer()
    return variable

def cnn_encoder(data):
    # print('data_input', data.shape)
    # aa=data[-1]#输入的是计算的协方差误差，也就是第一个图的误差
    """

    :param data: the input data size is 3 * 36 * 36 * 3
    :return:
    """
    # the first layer,the output size is 30 * 30 * 32
    filter1 = tensor_variable([3, 3, 1, 8], "filter1")
    strides1 = (1, 1, 1, 1)
    cnn1_out = cnn_encoder_layer(data, filter1, strides1)
    print('cnn1_out', cnn1_out.shape)
    # the second layer, the output size is 15 * 15 * 64
    filter2 = tensor_variable([3, 3, 8, 16], "filter2")
    strides2 = (1, 2, 2, 1)
    cnn2_out = cnn_encoder_layer(cnn1_out, filter2, strides2)
    print('cnn2_out',cnn2_out.shape)
    # the third layer, the output size is 8 * 8 * 128
    filter3 = tensor_variable([2, 2, 16, 32], "filter3")
    strides3 = (1, 2, 2, 1)
    cnn3_out = cnn_encoder_layer(cnn2_out, filter3, strides3)
    print('cnn3_out', cnn3_out.shape)
    # the fourth layer, the output size is 4 * 4 * 256
    filter4 = tensor_variable([2, 2,32, 64], "filter4")
    strides4 = (1, 2, 2, 1)
    cnn4_out = cnn_encoder_layer(cnn3_out, filter4, strides4)
    print('cnn4_out', cnn4_out.shape)
    return cnn1_out, cnn2_out, cnn3_out, cnn4_out

def cnn_lstm_attention_layer(input_data, layer_number):
    """

    :param input_data:
    :param layer_number:
    :return:
    """
    # convlstm_layer = tf.contrib.rnn.ConvLSTMCell(
    convlstm_layer = tf.compat.v1.nn.rnn_cell.LSTMCell(
        conv_ndims=2,
        input_shape=[input_data.shape[2], input_data.shape[3], input_data.shape[4]],
        output_channels=input_data.shape[-1],
        kernel_shape=[2, 2],
        use_bias=True,
        skip_connection=False,
        forget_bias=1.0,
        initializers=None,
        name="conv_lstm_cell" + str(layer_number))

    outputs, state = tf.nn.dynamic_rnn(convlstm_layer, input_data, dtype=input_data.dtype)
    # attention based on inner-product between feature representation of last step and other steps
    attention_w = []
    for k in range(util.step_max):
        attention_w.append(tf.reduce_sum(tf.multiply(outputs[0][k], outputs[0][-1])) / util.step_max)#outputs1,3,36,36,8 outputs[0] 3,36,36,8
    attention_w = tf.reshape(tf.nn.softmax(tf.stack(attention_w)), [1, util.step_max])#stack 增加一个维度  softmax使得向量中数值较大的量特征更加明显。

    outputs = tf.reshape(outputs[0], [util.step_max, -1])
    outputs = tf.matmul(attention_w, outputs)
    outputs = tf.reshape(outputs, [1, input_data.shape[2], input_data.shape[3], input_data.shape[4]])

    return outputs, attention_w

def cnn_decoder_layer(conv_lstm_out_c, filter, output_shape, strides):
    """

    :param conv_lstm_out_c:
    :param filter:
    :param output_shape:
    :param strides:
    :return:
    """

    deconv = tf.nn.conv2d_transpose(
        value=conv_lstm_out_c,
        filter=filter,
        output_shape=output_shape,
        strides=strides,
        padding="SAME")
    deconv = tf.nn.selu(deconv)
    return deconv

def cnn_decoder(lstm1_out, lstm2_out, lstm3_out, lstm4_out):
    print('lstm4_out_size',lstm4_out.shape)
    d_filter4 = tensor_variable([2, 2, 32, 64], "d_filter4")
    dec4 = cnn_decoder_layer(lstm4_out, d_filter4, [1, 9, 9, 32], (1, 2, 2, 1))
    dec4_concat = tf.concat([dec4, lstm3_out], axis=3)#最后一个维度拼接 不增加维度
    print('dec4_concat_size', dec4_concat.shape)
    print('lstm3_out_size', lstm3_out.shape)
    d_filter3 = tensor_variable([2, 2, 16, 64], "d_filter3")
    dec3 = cnn_decoder_layer(dec4_concat, d_filter3, [1, 18, 18, 16], (1, 2, 2, 1))
    dec3_concat = tf.concat([dec3, lstm2_out], axis=3)
    print('size', dec3_concat.shape)
    d_filter2 = tensor_variable([3, 3, 8,32], "d_filter2")
    dec2 = cnn_decoder_layer(dec3_concat, d_filter2, [1, 36, 36, 8], (1, 2, 2, 1))
    dec2_concat = tf.concat([dec2, lstm1_out], axis=3)
    print('size', dec2_concat.shape)
    d_filter1 = tensor_variable([3, 3, 1, 16], "d_filter1")
    dec1 = cnn_decoder_layer(dec2_concat, d_filter1, [1, 36, 36, 1], (1, 1, 1, 1))
    return dec1

def main():
    # Read dataset from file
    matrix_data_path = util.train_data_path + "train_negative.npy"
    matrix_gt_1 = np.load(matrix_data_path)
    matrix_gt_1 = matrix_gt_1.reshape(12000,3,36, 36,1)
    # sess = tf.Session()
    tf.compat.v1.Session()
    tf.compat.v1.disable_eager_execution()
    data_input = tf.compat.v1.placeholder(tf.float32, [util.step_max, 36, 36, 1])
    # cnn encoder
    conv1_out, conv2_out, conv3_out, conv4_out = cnn_encoder(data_input)
    conv4_out_reshape1=  conv4_out[-1,:,:,-1]
    conv4_out_reshape2 = conv4_out[0, :, :, -1]
    conv4_out_reshape3 = conv4_out[1, :, :, -1]
    #算mmd与高斯分布
    lossconv1=tf.square(MMD(tf.reshape(conv4_out_reshape1,[5,5]),tf.reshape(conv4_out_reshape2,[5,5]),beta=1))
    lossconv2= tf.square(MMD(tf.reshape(conv4_out_reshape1, [5,5]), tf.reshape(conv4_out_reshape3,[5,5]),beta=1))
    lossconv3 = tf.square(MMD(tf.reshape(conv4_out_reshape2, [5,5]), tf.reshape(conv4_out_reshape3, [5,5]),beta=1))
    lossconv=lossconv1+lossconv2+lossconv3
    conv1_out = tf.reshape(conv1_out, [-1, 3, 36, 36,8])
    conv2_out = tf.reshape(conv2_out, [-1, 3, 18, 18, 16])
    conv3_out = tf.reshape(conv3_out, [-1, 3, 9, 9, 32])
    conv4_out = tf.reshape(conv4_out, [-1, 3, 5, 5, 64])
    #
    # # lstm with attention 将生成的权重向量与每一个时间步的特征做乘法，使得模型能够更加关注重要特征。refer to cnn_lstm_attention_layer

    conv1_lstm_attention_out, atten_weight_1 = cnn_lstm_attention_layer(conv1_out, 1)
    conv2_lstm_attention_out, atten_weight_2 = cnn_lstm_attention_layer(conv2_out, 2)
    conv3_lstm_attention_out, atten_weight_3 = cnn_lstm_attention_layer(conv3_out, 3)
    conv4_lstm_attention_out, atten_weight_4 = cnn_lstm_attention_layer(conv4_out, 4)

    # # cnn decoder
    deconv_out = cnn_decoder(conv1_lstm_attention_out, conv2_lstm_attention_out, conv3_lstm_attention_out,
                             conv4_lstm_attention_out)
    # print('outshape',deconv_out.shape)
    # loss function: reconstruction error of last step matrix
    loss = tf.reduce_mean(lambda1*tf.square(data_input[-1] - deconv_out)+lambda2*(lossconv/3))
    # loss = tf.reduce_mean(lambda1 * tf.square(data_input[-1] - deconv_out))
    optimizer = tf.compat.v1.train.AdamOptimizer(learning_rate=util.learning_rate).minimize(loss)

    # variable initialization
    init = tf.global_variables_initializer()
    sess.run(init)
    train_num = matrix_gt_1.shape[0]
    trainingerror = np.zeros(shape=(int(train_num), 1))
    trainnum=int(0)
    # training
    for idx in range(util.train_start_id, util.train_end_id):
        matrix_gt = matrix_gt_1[idx - util.train_start_id]
        feed_dict = {data_input: np.asarray(matrix_gt)}
        a, loss_value = sess.run([optimizer, loss], feed_dict)
        print("mse of last train data: " + str(loss_value))
        trainingerror[idx]=str(loss_value)
        if int(loss_value) < int(1.5):
            trainnum += int(1)
    print('trainnum', trainnum)
    #
    # 创建Saver()节点
    # saver = tf.train.Saver()
    #
    #     # 恢复sess
    #     ckpt = tf.train.get_checkpoint_state('./ckpt/')
    #     if ckpt and ckpt.model_checkpoint_path:
    #         saver.restore(sess, ckpt.model_checkpoint_path)
    #     else:
    #         sess.run(tf.global_variables_initializer())
    #     ...
        # save_path = saver.save(sess, "./ckpt/my_model_final.ckpt")
    # training end
    # 加载模型
    # saver = tf.train.import_meta_graph("./ckpt/my_model_final.ckpt.meta")
    # saver.restore(sess, tf.train.latest_checkpoint("./ckpt"))
    #测试
'''
    list=[]
    threshold=[]
    for x in range(5):
        threshold.append(3+x*0.5)
    for thre in range(len(threshold)):
        # test positive   # Read the data from test file.
        matrix_data_path = util.test_data_path + "train1.npy"
        matrix_gt_1 = np.load(matrix_data_path)
        pos_num = matrix_gt_1.shape[0]
        matrix_gt_1 = matrix_gt_1.reshape(500, 3, 36, 36, 1)
        testnum = int(0)
        for idx in range(util.train_start_id, util.train_end_id):
            matrix_gt = matrix_gt_1[idx - util.train_start_id]
            feed_dict = {data_input: np.asarray(matrix_gt)}
            result, loss_value = sess.run([deconv_out, loss], feed_dict)
            # result_all.append(result)
            print("mse of last test_positive data: " + str(loss_value))
            if int(loss_value)<int(threshold[thre]):
                testnum+=int(1)
        TP=pos_num-testnum
        FP=testnum
        print(testnum)
            # print('testnum',testnum)
            # testingerroraver = np.sum(testingerror) / len(testingerror)
            # print('trainerror', testingerroraver)
            # test negative

        matrix_data_path = util.test_data_path + "train_negative.npy"
        matrix_gt_1 = np.load(matrix_data_path)
        matrix_gt_1 = matrix_gt_1.reshape(8000, 3, 36, 36, 1)
        testnum = int(0)
        neg_num = matrix_gt_1.shape[0];
        for idx in range(util.test_start_id, util.test_end_id):
            matrix_gt = matrix_gt_1[idx - util.test_start_id]
            feed_dict = {data_input: np.asarray(matrix_gt)}
            result, loss_value = sess.run([deconv_out, loss], feed_dict)
            print("mse of last test_negative data: " + str(loss_value))
            if int(loss_value) > int(threshold[thre]):
                testnum += int(1)
        FN=testnum
        TN=neg_num-testnum
        print('testnum', testnum)
            # testingerroraver = np.sum(testingerror) / len(testingerror)
            # print('trainerror', testingerroraver)
        precision=TP/(TP+FP)
        recall=TP/(TP+FN)
        f_score=2*(precision*recall)/(precision+recall)
        print('precision', precision)
        print('recall', recall)
        print('f_score', f_score)
        line = [precision, recall, f_score]
        list.append(line)
        print(list)
    # Write the reconstructed matrix to the file
    # reconstructed_path = util.reconstructed_data_path
    # if not os.path.exists(reconstructed_path):
    #     os.makedirs(reconstructed_path)
    # reconstructed_path = reconstructed_path + "test_reconstructed.npy"
    #
    # result_all = np.asarray(result_all).reshape((-1, 36, 36, 1))
    # print(result_all.shape)
    # np.save(reconstructed_path, result_all)
'''
if __name__ == '__main__':
    main()
