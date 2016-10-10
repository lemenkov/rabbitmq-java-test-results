URI="amqp://guest:VU6jYn7g4EJeggnPq9PQTMdvW@172.17.0.22:5672"

for i in 1 5 10 20 50
do
	sh runjava.sh com.rabbitmq.examples.PerfTest -x ${i}  -y ${i} --uri ${URI} -s 1000 -z 60 -a 2>&1 | tee autoack-${i}.log
	sh runjava.sh com.rabbitmq.examples.PerfTest -x ${i}  -y ${i} --uri ${URI} -s 1000 -z 60 2>&1 | tee ack-${i}.log
	sh runjava.sh com.rabbitmq.examples.PerfTest -x ${i}  -y ${i} --uri ${URI} -s 1000 -z 60 -c 1000 2>&1 | tee ack-confirm-${i}.log
	sh runjava.sh com.rabbitmq.examples.PerfTest -x ${i}  -y ${i} --uri ${URI} -s 1000 -z 60 -c 1000 -f persistent 2>&1 | tee ack-confirm-persistent-${i}.log
done
