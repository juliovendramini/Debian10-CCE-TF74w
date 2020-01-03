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

Adicione a linha abaixo no arquivo /etc/apt/sources.list :
```bash
deb http://deb.debian.org/debian buster-backports main contrib non-free
```

Depois instale o novo kernel (5.3):
```bash
apt-get update
apt-get -t buster-backports install linux-image-5.3.0-0.bpo.2-686-unsigned 
```

# Instalando os firmwares non-free

Para o tablet funcionar, são necessários vários binários de firmware espalhados pela net. Vou linkar os locais aqui pra não ter problema futuros com licença ou permissão de postagem. Todos eles também se encontram no github.
O kernel reclama da falta dos firmwares, então é só olhar o log utilizando o comando dmesg que saberemos quais estão faltando. Todos os firmwares devem ser colocados na pasta /lib/firmware, alguns ainda dentro de subpasta específica (da pra saber pelo log).
  * Firmware i915: 

Você precisa dos drivers non-free realtek para o wifi funcionar.





# Fontes de consulta
* https://gist.github.com/jfstenuit/09feac5ab0bff500db81ac9a56a48773

