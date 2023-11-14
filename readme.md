# Belajar Kubernetes
Panduan ini akan menjelaskan secara singkat terkait dengan kubernetes

## Installasi Kubernetes
Sebagai contoh untuk installasi kubernetes ini akan kita lakukan pada sistem operasi ubuntu, untuk sistem operasi lainnya dapat menyesuaikan pada dokumentasi resmi yang ada. Installasi ini umumnya dilakukan pada master-node dan worker-node.

### Instan Install

Saya telah menyediakan sebuah bash script yang sudah diisikan script installasi service untuk kebutuhan kubernetes yang dapat anda install dengan melakukan git clone pada repo ini.

```
git clone https://github.com/tresnax/tutorial-kubernetes.git
cd tutorial-kubernetes/
chmod +x k8s-install.sh
sudo ./k8s-install.sh
```

### Normal Install
Apabila anda ingin melakukan installasi bertahap seperti biasa, anda dapat mencobanya dengan 2 langkah berikut ini.


**Install Docker Service**
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] \ 
   https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Install Kubernetes Service**
```
apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt update
apt install -y kubelet kubeadm kubectl

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd.service
```

## Konfigurasi
#### Master Node
Setelah installasi kubernetes service berhasil dilakukan, selanjutnya kita akan melakukan init untuk mengidentifikasi master-node.

```
sudo kubeadm init
```
Tunggu hingga proses init selesai dilakukan, selanjutnya lakukan konfigurasi directory.
```
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```
Install network addson pada master-node agar status node menjadi ready dan matikan isolasi mode.
```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```
Masukan perintah berikut untuk mendapatkan credential, setelah itu copy hasilnya dan jalankan perintah tersebut pada worker-node.
```
sudo kubeadm token create --print-join-command
```
Pastikan bahwa worker node sudah bergabung dengan cluster dengan menggunakan perintah berikut.
```
kubectl get nodes
```

### Worker Node
Pada worker node hanya perlu menjalankan command yang dihasilkan dari print token yang dilakukan pada master node. Setelah itu worker node akan dinyatakan bergabung dengan cluster.

## Roadmap

**Comming Soon**