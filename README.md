# DeepPipe2
DeepPipe2 is a library of Deep-Learning by Elixir using GPU. It is fast because it uses CUDA/cuBLAS. 

Currently, I am improving to use CNN.

# getting started
DeepPipe2 requires GPU. Nvidia's GeForce is easy. The game PC turns into an AI experiment tool.

If you have not yet installed CUDA, install it from the Nvidia website.
https://developer.nvidia.com/cuda-downloads

Linux is recommended for OS. DeepPipe2 does not work on Windows.
After installing CUDA, make a clone of DeepPipe2.
git clone https://github.com/sasagawa888/deeppipe2.git

Change to the deeppipe2 directory with the CD command. And enter make from terminal. Installation is completed. Start with iex -S mix.MNIST data and sample code are included. Enter Test.sgd (100,100).

Network descriptions are Elixir-like pipeline operators. See the test.ex file. The random number given to the weight matrix and bias affects learning. The learning rate also has an effect. The default for each is 0.1. You can change it with w(300,100,0.2,0.5) in defnetwork. In this example, the multiple to the random number is 0.2 and the learning rate is 0.5. It is important to find these parameters in Deep-Learning.

Please enjoy.



## install
require CUDA.

Make clone or download.

on terminal 

```
$make
$iex -S mix

```

## example
MNIST 100 mini batch size, 100 times repeat.

```
iex(1)> Test.sgd(100,100)
preparing data
learning start
100 2.204291343688965
99 2.0511350631713867
98 1.851050615310669
97 1.7592202425003052
96 1.7395706176757813
95 1.6045866012573242
94 1.5952904224395752
93 1.4877655506134033
...
7 0.4388183653354645
6 0.49198096990585327
5 0.5398643016815186
4 0.43334200978279114
3 0.47159287333488464
2 0.37558087706565857
1 0.37841811776161194
learning end
accuracy rate = 0.8495
"time: 4.006799 second"
"-------------"
:ok
iex(2)> 

```

## confirmation
I confirmed following OS and CUDA

Linux Mint 18.1 “Sarah” MATE


```
nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2019 NVIDIA Corporation
Built on Wed_Oct_23_19:24:38_PDT_2019
Cuda compilation tools, release 10.2, V10.2.89
```


## network example
see test.ex

```
# for DNN test
  defnetwork init_network1(_x) do
    _x |> w(784,300) |> b(300) |> relu
    |> w(300,100) |> b(100) |> relu
    |> w(100,10) |> b(10) |> softmax
  end
```

## describe network

```
defnetwork  name(_x) do
  _x |> element of network |> ...
end

```

element 

- w(r,c)  weight matrix row-size is r col-size is c. initial val is random * 0.1, default learning late 0.1
- w(r,c,ir,lr) ir is initial rate to multiple randam, lr is learning rate.
- w(r,c,ir,lr,dr) dr is dropout rate.
- b(n) bias row vector size n.  initial val is randam * 0.1, default learning late 0.1 
- b(n,ir,lr) ir is initial rate to multiple randam, lr is learning rate.
- b(n,ir,lr,dp) dr is dropout rate.
- activate function  leru sigmoid tanh softmax
- f(r,c) filter matrix row-size is r col-size is c. input and output channel is 1, initial val random * 0.1, default learning late 0.1
- f(r,c,i)  filter matrix. i input channel.
- f(r,c,i,o) filter matrix. o output channel
- f(r,c,i,o,{st_h,st_w}) filter matrix. st_h and st_w are stride size od hight and width.
- f(r,c,i,o,{st_h,st_w},pad) filter matrix. pad is padding size. 
- f(r,c,i,o,{st_h,st_w},pad,ir,lr) filter matrix. ir is rate for initial val, lr is learning rate.
- pooling(st_h,st_w) st_h and st_w are pooling size.
- full    convert from image of CNN to matrix for DNN.
 

## specification:

### data structure
#### network
[{:weight,w,ir,lr,v},{:bias,b,ir,lr},{:function,name}, ...]
##### weight
{:weight,w,ir,lr,dp,v} w is matrix, ir is rate for initial random number,lr is learning rate, dp is dropout rate, v is for momentum,adagrad,adam
##### bias
{:bias,b,ir,lr,dp,v} b is row vector
##### function
{:function,name} name is function name within sigmoid tanh relu

### module macros
defnetwork is macros to describe network
argument must have under bar to avoid warning message

##### w(m,n)
weight matrix size(m,n). elements are Gaussian distribution random float
##### w(m,n,,ir,lr,dr)
ir is rate for random number. (default is 0.1)
lr is learning rate (default is 0.1)
dr is dropout rate %(0.0~100.0) (default is 0.0)

##### b(n)
bias row_vector size(n). elements are all zero

#### b(n,ir,lr)
ir is rate for random number. (default is 0.1)
lr is learning rate (default is 0.1)

#### function
sigmoid,tanh,relu,softmax

#### filter(convolution)
{:filter,w,st,pad,ir,lr,dp,v}

#### pooling
{:pooling,st}



## module Deeppipe
- forward/3

```
return all middle data
1st arg is input data matrix
2nd arg is network list
3rd arg is generated middle layer result
```

- gradient/3

```
gradient with backpropagation
1st arg is input data matrix
2nd arg is network list
3rd arg is train matrix
```

- learn/2 learn/3

```
learning/2 
1st arg is old network list
2nd arg is network with gradient
generate new network with leared weight and bias
update method is sgd

learning/3
added update method to 3rd arg
update method is sgd, momentam, adagrad

```

- train/9

```
1st arg network
2nd arg train image list
3rd arg train onehot list
4th arg test image list
5th arg test labeel list
6th arg loss function (;cross or :squre)
7th arg minibatch size
8th arg lewarning method
9th arg repeat number

```




## module cuMatrix
Caution, each element of matrix  must be float number.

- Cumatrix.new(r,c) 
generate matrix with given row col size. Each elements are zero.

- Cumatrix.new(r,c,val)
generate matrix with given row col size. Each elements are val.

- Cumatrix.new(list)
generate matrix with given list. e.g. [[1,2],[3,4]].

- Cumatrix.rand(r,c)
generate matrix with random (Box-muller).

- Cumatrix.add(mt1,mt2)
generate matrix mt1+mt2. if mt1 or mt2 is row vector, expand size to matrix. This function is for bias add in DL.

- Cumatrix.sub(mt1,mt2)
generate matrix mt1-mt2.

- Cumatrix.mult(mt1,mt2)
generate matrix  mt1*mt2 with cuBLAS. 
if mt1 or mt2  is float number. generate matrix that each element is s*elt(x,y)

- Cumatrix.emult(mt1,mt2)
generate Hadamard matrix.

- Cumatrix.transpose(mt)
generate transposed matrix

- Cumatrix.ident(n) 
generate ident matrix of size n.

- Cumatrix.activate(mt,fun)
apply fun to mt. fun is :sigmoid, :tanh, :relu :softmax

- Cumatrix.size(mt)
return tuple {rowsize,colsize}

- Cumatrix.sum(mt)
return sum of elements

- Cumatrix.to_list(mt)
return list that transformed from matrix

- Cumatrix.trace(mt)
return float number. It is trace of matrix.

- Cumatrix.print(mt)
print matrix mt

- Cumatrix.elt(mt,r,c) 
pick up element of mt(r,c) index is one base

- Cumatrix.set(mt,x,y,val)
elt(mt,x,y) := val. 

- Cumatrix.average(mt)
caluculate average of row-vector and generate row-vector that each element is average.
For Deep-Learning.  

- Cumatrix.loss(mt1,mt2,fun)
generate float that is average of loss. fun is :square or :cross.
:square means mean_square function, and :cross means cross_entropy function.
mt1 is calculated data matrix , mt2 is train data matrix.
each data is row vector.

- Cumatrix.diff(mt1,mt2,fun)
for each element multiply differntial of mt2 and mt1. fun is :sigmoid :tanh, :relu.

- Cumatrix.momentum(mt1,mt2,mt3,lr,dr)
for each element
v = 0.5 * mt2(x,y) - lr * mt3(x,y).
w = mt1 + v.
and dropout w with dr.
return tuple {v,w}
for learn/3 in DeepPipe2

- Cumatrix.adagrad(mt1,mt2,mt3,lr,dr)
for each element
h = mt2 + mt3*mt3.  
w = mt1 - lr * (1 / sqrt(h)) * mt2. 
and dropout w with dr.
return tuple(h,w)
for learn/3 in DeepPipe2

- Cumatrix.accuracy(mt1,ls) 
return accuracy rate as float number.
mt1 is set of row-vector.Each row-vector is onehot.
ls is list each element is label integer number.

```
e.g.

iex(1)> a = Cumatrix.new([[0.0,0.0,1.0],[0.0,0.1,0.3]])
{2, 3,
 <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 205, 204, 204, 61, 0, 0, 128, 63, 154,
   153, 153, 62>>}
iex(3)> Cumatrix.accuracy(a,[2,2])
1.0
iex(4)> Cumatrix.accuracy(a,[2,1])
0.5
iex(5)> 

```

## CNN
Now testing.

```
# for CNN test for MNIST
  defnetwork init_network4(_x) do
    _x
    #|> visualizer(1,1)
    |> f(5, 5, 1, 12, {1,1}, 1, 0.5, 0.0001)
    |> pooling(2,2)
    |> f(3, 3, 12, 12, {1,1}, 1, 0.5, 0.0001)
    |> f(2, 2, 12, 12, {1,1}, 1, 0.5, 0.0001)
    |> pooling(2,2)
    |> f(3, 3, 12, 12, {1,1}, 0, 0.5, 0.0001)
    |> relu
    #|> visualizer(1,1)
    |> full
    |> w(300, 10, 0.1, 0.001)
    |> softmax
  end

```

data structure is 4-dimensions tensor (N,C,H,W) or 3-dimension tensor (C,H,W)
N is mini batch size.
C is channel.
H is hight of image.
W is width of image.

- Cumatrix.rand(n,c,h,w)
generate 4 dimensions data.

- Cumatrix.rand(c,h,w)
generate 3 dimensions data.

- Cumatrix.new(ls)
ls is list that express 4-dimension or 3-dimension data

- Cumatrix.to_list(tensor)
tensor is 3-dimension or 4-dimension

- Cumatrix.pooling(tensor,st_h,st_w)
pooling with stride st_w st_w. size of H and W must be less 1000. max 999*999. return tuple {tensor-for-forward,tensor-for-backward}

- Cumatrix.unpooing(ts1,ts2,st_h,st_w)
unpooling with stride st.
ts1 is sparse tensor that save index of max element. ts2 is loss tensor.

- Cumatrix.convolute(ts1,ts2,st_h,st_w,pad)
convolution with input-tensor(ts1), filter-tensor(ts2), stride(st_h,st_w), padding(pad)

- Cumatrix.deconvolute(ts1,ts2,st_h,st_w,pad)
deconvolution with input-tensor(ts1), filter-tensor(ts2), stride(st_h,st_w), padding(pad)

- Cumatrix.gradfilter(ts1,ts2,ts3,st,pad)
gradient by backpropagation. ts1 is input-tesor, ts2 is filter-tensor, ts3 is loss-tensor, st is stride size, pad is padding size.

- Cumatrix.full(ts) 
transfer from 4 DIM tensor to matrix.

- Cumatrix.unfull(mt,h,w)
transfer from matrix to 4 DIM tensor. tensor(N,C,H,W). N is row size of matrix. C is 1.

- Cumatrix.sgd(mt1,mt2,lr,dr)
element of mt1 - element of mt2*lr. and dropout with rate dr.

## error code

- N<10000  bad argument error   N is argument number. 
- 10000<= N <11000 CUDA error   N-10000 is error code of CUDA.
- 11000 < N  cuBLAS error  N-11000 is error code of cuBLAS.

## Hardware 
recommended  memory 8GB or moreover.

recommended GTX960 GPU or moreover.
