# Debian10-CCE-TF74w

# Introdução: 
Guia de instalação do Debian 10 no tablet CCE TF74w, este guis foi feito para auxiliar as pessoas que querem fazer o mesmo processo ou algo parecido. Não me responsabilizo por nada que der errado. Aqui temos basicamente um compilado de informações existentes na comunidade de software livre.

Este guia tem como objetivo instalar o Debian 10 32bits no tablet da CCE TF74w. O principal objetivo de uso é como servidor e painel para o OpenHab, um sistema de automação residencial Open-Source. 
Este manual mostra como instalar o Debian e configurar o Wifi, TouchScreen e Audio. Os demais dispositivos não são necessários, então não me preocupei.
Você vai precisar da boot via pendrive no tablet. Não vou entrar em detalhes como faz isso pois existe muito conteudo na internet falando sobre.

# Baixando o Debian 10:

Utilizei a versão NetInst para economizar espaço e coloquei o mínimo possível de pacotes. Depois fui instalando o que precisava. Mas a versão LiveCD também funcionou, mas ocupou espaço demais. 
* Segue o link da versão 32 bits: http://ftp.br.debian.org/debian-cd/10.2.0-live/i386/iso-hybrid/ qualquer versão ai funcionará, eu escolhi a com o LXDE por ser mais leve. Já que temos apenas 1GB de ram.
 
# Instalação do Debian

Eu particionei a memória dele em 14Gb em EXT4 e 1Gb de swap, porém não criei a partição SWAP, espero não precisar dela. Se precisar eu ativo.
 

# Kernel Novo

Após instalado, é necessário utilizar outro Kernel mais novo para dar mais compatibilidade com os dispositivos do tablet. Para isso faça o seguinte: (retirado e adaptado de: https://gist.github.com/jfstenuit/09feac5ab0bff500db81ac9a56a48773)

Adicione a linha abaixo no arquivo /etc/apt/sources.list (lembre-se de editar como sudo):
```bash
deb http://deb.debian.org/debian buster-backports main contrib non-free
```

Depois instale o novo kernel (5.3):
```bash
sudo apt-get update
sudo apt-get -t buster-backports install linux-image-5.3.0-0.bpo.2-686-unsigned 
```

# Instalando os firmwares non-free

Para o tablet funcionar, são necessários vários binários de firmware espalhados pela net. Vou linkar os locais aqui pra não ter problema futuros com licença ou permissão de postagem. Todos eles também se encontram no github.
O kernel reclama da falta dos firmwares, então é só olhar o log utilizando o comando dmesg que saberemos quais estão faltando. Todos os firmwares devem ser colocados na pasta /lib/firmware, alguns ainda dentro de subpasta específica (da pra saber pelo log).
Os firmwares necessários são:
  * Firmware i915, retirado de https://github.com/wkennington/linux-firmware/tree/master/i915
  * Firmware Realtek Wifi/Bluetooth, 
  * Firmware do Touchscreen Silead, 
Todos estão na pasta firmware deste repositório.  
Os que não estiverem na pasta, são instalados via repositório:
```bash
sudo apt-get install firmware-intel-sound firmware-realtek
```
Para instalar os firmware que estou fornecendo dentro deste repositório, entre na pasta firmware e digite:
```bash
 sudo cp -r * /lib/firmware/
```

# Configurando o TouchScreen
 O touchScreen utiliza o controlador Silead. O firmware do CCE TF74w já foi extraido e está na pasta do repositório. Para ele funcionar é preciso de um driver do controlador. Existem dois: o silead_ts e o gslx680_ts_acpi (fonte: https://github.com/onitake/gsl-firmware) o primeiro precisa de alterar código no kernel para incluir as configurações do touch. Desisti desse e parti pro outro, mesmo que não esteja mais em desenvolvimento. Já compilei o modulo do kernel pra essa versão 5.3 e coloquei no repositório, então é só instalar como nos passos abaixo. O link do código fonte é: (https://github.com/onitake/gslx680-acpi)

Após copiar a pasta firmware toda pra /lib/firmware, entre na pasta do que possui os módulos do kernel e digite:
```bash
 chmod +x instala_touch.sh
 sudo insmod gslx680_ts_acpi.ko
 sudo ./instala_touch.sh
``` 
# Configurando o Som
Para instalar o som, entre na pasta audio e copie o conteúdo dela utilizando o seguinte comando:
```bash
sudo cp -rf ./byt-rt5640 /usr/share/alsa/ucm
```
Após isso, rode o comando, este comando impede a detecção do audio HDMI pelo kernel, já que não temos conector hdmi :( :
```bash
echo 'blacklist snd_hdmi_lpe_audio' >> /etc/modprobe.d/50-block-hdmi-audio.conf
```
O Som deverá funcionar quando reiniciar o tablet.

# Outras informações
* Caso queira instalar outros dispositivos, principalmente os i2c, que são a maioria nesse tablet, digite o comando abaixo, ele lista todos os dispositivos, com essas informações, procure no google.
```bash
find /sys/devices/platform -name name -printf "%p\t" -exec cat {} \;
```

* Para criar o firmware do touch utilizei um comando passando parametros, vou disponibilizar aqui também para quem achar que o touch não está tão bom e queira testar uma calibração melhor. Link para referência: (https://github.com/onitake/gsl-firmware#gslx680_ts_acpi)
```bash
./fwtool -c firmware.fw  -m 1680 -w 940 -h 640 -t 5 -f track,xflip silead_ts.fw
```

# Outros sensores
Como não precisei de outros sensores, não me importei em tentar fazê-los funcionar. Caso tenha interesse e consiga algum avanço, peço que informe como para incluirmos neste manual. O link (https://gist.github.com/jfstenuit/09feac5ab0bff500db81ac9a56a48773) pode te ajudar.

# Fontes de consulta
* https://gist.github.com/jfstenuit/09feac5ab0bff500db81ac9a56a48773
* https://github.com/wkennington/linux-firmware/
* https://github.com/plbossart/UCM/tree/master/bytcr-rt5640

