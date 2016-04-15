# ����Ѹ���Ƽ๤��docker����
# �Ƽ๤ԭ����powergx

FROM tutum/ubuntu:trusty
MAINTAINER sanzuwu <sanzuwu@gmail.com>

RUN rm /bin/sh &&  ln -s /bin/bash /bin/sh

#����ʱ��Ϊ����ʱ��
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#����ʱ��������
#RUN ntpdate  ntp1.aliyun.com

#���£���װgit��wget��sudo
RUN apt-get update && apt-get install -y git wget sudo vim nginx curl

#��������Ŀ¼
RUN mkdir /app 
RUN cd /app
#�����Ƽ๤Դ����
RUN git clone https://github.com/sanzuwu/crysadm.git
#��Ӽƻ�����ÿСʱ�����Ƽ๤
#RUN echo '0 * * * * root sh /app/crysadm/run.sh' >> /etc/crontab

#��װpython��redis
RUN apt-get install -y python3.4 python3.4-dev redis-server
RUN chmod +x ./crysadm/get-pip.py
RUN python3.4 ./crysadm/get-pip.py
RUN pip3.4 install redis && sudo pip3.4 install requests && sudo pip3.4 install flask

#���������ļ�
RUN mv /etc/nginx/sites-available/default ./
COPY default /etc/nginx/sites-available/
RUN apt-get clean 

#�ű�������Ȩ��
RUN chmod +x ./crysadm/run.sh ./crysadm/down.sh ./crysadm/setup.sh  ./crysadm/cron.sh
#redis���ݿⱣ��Ŀ¼
VOLUME ["/var/lib/redis"]

#���������˿�
#���÷������˿�
EXPOSE 80
#�Ƽ๤�˿�
EXPOSE 4000
#ssh�˿�
EXPOSE 22

WORKDIR /app

RUN chmod +w /set_root_pw.sh
#������нű�
RUN echo "/app/crysadm/run.sh" >>/set_root_pw.sh
#RUN echo "cron start" >>/set_root_pw.sh
RUN echo "service nginx start" >>/set_root_pw.sh
RUN echo "service nginx reload" >>/set_root_pw.sh
RUN echo "/bin/bash" >>/set_root_pw.sh
