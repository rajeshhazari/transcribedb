!#/bin/sh
#devserver-deepspeech-install-doc
#https://github.com/mozilla/DeepSpeech

$(lsb_release -cs)
mkdir /opt/apps/python-deepspeech/
export APP_HOME=/opt/apps
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
apt install virtualenv deepspeech -y
pip install deepspeech  --upgrade pip
pip install --upgrade virtualenv
alias python3='/usr/bin/python3.7'

python --version

# Create and activate a virtualenv
virtualenv -p python3 $APP_HOME/tmp/deepspeech-venv/
chmod +x $APP_HOME/tmp/deepspeech-venv/bin/activate
$APP_HOME/tmp/deepspeech-venv/bin/activate


# Download pre-trained English model and extract
curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/deepspeech-0.6.1-models.tar.gz
tar xvf deepspeech-0.6.1-models.tar.gz

# Download example audio files
curl -LO https://github.com/mozilla/DeepSpeech/releases/download/v0.6.1/audio-0.6.1.tar.gz
tar xvf audio-0.6.1.tar.gz

# Transcribe an audio file
deepspeech --model deepspeech-0.6.1-models/output_graph.pbmm --scorer deepspeech-0.6.1-models/kenlm.scorer --audio audio/2830-3980-0043.wav
