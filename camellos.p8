pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- camel race
-- by javi y teo prieto

function inicializaflecha()
 flecha=flr(rnd(3+dificultad))
end

function darnombrecorredor(i)
 while corredor[i][5]==-1 do
  corredor[i][5]=1+flr(rnd(#nombrecorredor))
  for j=1,i-1 do
   if corredor[i][5]==corredor[j][5] then
    corredor[i][5]=-1
   end
  end
 end
end

function darsprcorredor(i)
 while corredor[i][4]==-1 do
  corredor[i][4]=1+flr(rnd(6))
  for j=1,i-1 do
   if corredor[i][4]==corredor[j][4] then
    corredor[i][4]=-1
   end
  end
 end
end

function dibujarcamello(ncorredor)
 x=corredor[ncorredor][1]
 y=corredor[ncorredor][2]
 paso=corredor[ncorredor][3]
 numspr=corredor[ncorredor][4]
 nombre=nombrecorredor[corredor[ncorredor][5]]
 if modo==1 then --estamos en el menu
  x=56-25+50*((ncorredor+1)%2)
	 y=16+(ncorredor-1)*20
	 paso=1
	elseif modo==4 then --estamos en los resultados
	 paso=1
	 if ncorredor==primero then
	  x=56
	  y=53
	 elseif ncorredor==segundo then
	  x=40
	  y=56
	 elseif ncorredor==tercero then
	  x=72
	  y=57
	 else
	  x=104
	  y=25
	 end
 end
 --dibuja sombra
 sspr(56,16,16,16,x,y)

 --los pasos 2 y 3 son mas altos en la carrera
 if (paso==2 or paso==3) and modo==2 then
  y=y-1
 end

 --dibujar camello
 if turbo>0 and ncorredor==jugador then
  sspr(sprcamelloturbo[1],sprcamelloturbo[2],16,16,x,y)
 else
  sspr(sprcamello[paso][1],sprcamello[paso][2],16,16,x,y)
 end
 --dibujar corredor
 sspr(sprcorredor[numspr][1],sprcorredor[numspr][2],16,16,x,y)
 --dibujarnombre
 if modo==1 then --estamos en el menu
  color=7
	 if ncorredor==jugador then
	  color=8
      nombre="● "..nombre.." ●"
	 end
 else
  color=4
	 if ncorredor==jugador then
	  color=8
	 end
 end
 
 if modo!=4 then print(nombre,x+8-#nombre*2,y+17,color) end
end

function dibujarvegetacion(numvegetacion)
 sspr(
  sprarbol[vegetacion[numvegetacion][1]][1],
  sprarbol[vegetacion[numvegetacion][1]][2],
	 16,24,
	 vegetacion[numvegetacion][2],
	 posicionvegetacion[vegetacion[numvegetacion][3]]
	 )
end

function dibujarlineavegetacion(linea)
	for m=1,nvegetacion do
	 if vegetacion[m][3]==linea then
		 dibujarvegetacion(m)
		end
	end
end

function dibujarflecha(brillo)
 if turbo==0 then
	 direccion=flecha+1
	 if brillo==false then
	  sprx=sprflecha[direccion][1]
	  spry=sprflecha[direccion][2]
	 else
	  sprx=sprflechabrillo[direccion][1]
	  spry=sprflechabrillo[direccion][2]
	 end
	 --dibuja la flecha a la izda. del jugador
	 sspr(
	  sprx,spry,
	  8,8,
	  corredor[jugador][1]-24,
	  corredor[jugador][2]+8)
	 --dibuja la flecha a la dcha. del jugador
	 sspr(
	  sprx,spry,
	  8,8,
	  corredor[jugador][1]+32,
	  corredor[jugador][2]+8)
 end
end

function drawportada()
 map(48,0,0,0,16,16)
 printcenter(texto[1][idioma],40,1)
 printcenter(texto[2][idioma],50,7)

 printcenter(texto[17][idioma],110,6)
 printcenter(texto[18][idioma],118,6)

 if idioma==1 then
  printcenter(texto[3][idioma],70,2)
  printcenter("● "..texto[4][idioma].." ●",80,8)
 else
  printcenter("● "..texto[3][idioma].." ●",70,8)
  printcenter(texto[4][idioma],80,2)
 end

 sspr(sprflecha[1][1],sprflecha[1][2],8,8,6,117)
 sspr(sprflecha[2][1],sprflecha[2][2],8,8,16,117)
 sspr(sprflecha[3][1],sprflecha[3][2],8,8,26,117)
 sspr(sprflecha[4][1],sprflecha[4][2],8,8,36,117)
 
 sspr(sprflecha[5][1],sprflecha[4][2],8,8,89,117)
 sspr(sprflecha[6][1],sprflecha[4][2],8,8,106,117)


 --dibuja el camello
 x=56
 y=20
 sspr(56,16,16,16,x,y)
 npaso=flr(pasoportada/4)+1
 sspr(sprcamello[npaso][1],sprcamello[npaso][2],16,16,x,y)
 sspr(sprcorredor[spriteportada][1],sprcorredor[spriteportada][2],16,16,x,y)
 
 pasoportada+=1
 if pasoportada==16 then pasoportada=1 end
 
end

function updateportada()
 if btn(2) then idioma=2 end
 if btn(3) then idioma=1 end
 if btn(4) or btn(5) then
   while btn(4) or btn(5) do
    flip()
   end
  initmenu()
  end
end

function _init()
 --modos: 0 - portada, 1 - portada, 2 - carrera
 modo=0
 music(40)
  
 --textos
 idioma=2
 texto={{}}
 texto[1]={"carrera de camellos","camel race"}
 texto[2]={"pulsa un boton para comenzar","press any button to start"}
 texto[3]={"ingles","english"}
 texto[4]={"castellano","spanish"}
 texto[5]={"elige corredor","select a jockey"}
 texto[6]={"dificultad","difficulty"}
 texto[7]={"preparados","ready"}
 texto[8]={"listos","set"}
 texto[9]={"!ya!","go!"}
 texto[10]={"ganadores - vuelta ","winners - lap "}
 texto[11]={"pulsa cualquier boton","press any button"}
 texto[12]={"para mover a tu corredor","to move your jockey forward"}
 texto[13]={"pulsa la tecla del icono","press the same key as"}
 texto[14]={"que aparece a su lado","the icon next to him"}
 texto[15]={"ganador","winner"}
 texto[16]={"segundo","second"}
 texto[17]={"teclas","key mapping"}
 texto[18]={
  "         cursores     z   x",
  "         arrow keys   z   x"}
 texto[19]={"segunda vuelta","second lap"}
 texto[20]={"atento al nuevo icono","pay attention to the new icon"}
 texto[21]={"ultima vuelta","last lap"}
 texto[22]={"vuelta","lap"}
 texto[23]={"aparecen todos los iconos","all controls are in play"}
 texto[24]={" de 3"," of 3"} 
 texto[25]={"ganador","winner"}
 texto[26]={"segundo","second"}
 texto[27]={"tercero","third"}
 texto[28]={"puntos","points"}
 texto[29]={"enhorabuena: eres el ganador","congratulations: you win"}
 texto[30]={"has quedado segundo","second place"}
 texto[31]={"has quedado tercero","third place"}
 texto[32]={"mejor suerte en la proxima","better luck next time"}
 texto[33]={"seg","sec"}
 texto[34]={"record actual: ","current record: "}
 texto[35]={" puntos ("," points ("}
 texto[36]={" seg.)"," sec.)"}
 texto[37]={"!nuevo record!","new record!"}
 texto[38]={"te has fijado en la bandera?","have you notticed the flag?"}
 texto[39]={"nombre: ","name: "}

 --sprite para la portada
 pasoportada=1
 spriteportada=1+flr(rnd(6))

 --nombres de los corredores
 nombrecorredor={
  "ali-oli",
  "al-hambra",
  "abi-abe",
  "al-cala",
  "ali-ala",
  "ali-baba",
  "ali-kates",
  "abi-lala",
  "ali-cacafu",
  "ali-caca",
  "alum-bolum",
  "ali-ladino"}

 --sprites (corredores, camellos, vegetacion, flechas...)
 sprcorredor={{8,0},{8,16},{24,16},{40,16},{80,0},{80,16}}
 sprcamello={{24,0},{40,0},{56,0},{40,0}}
 sprcamelloturbo={112,16}
 nsprarbol=8
 sprarbol={{0,32},{16,32},{32,32},{48,32},{64,32},{80,32},{96,32},{112,32}}
 sprflecha={{0,72},{16,72},{24,72},{8,72},{32,72},{40,72}} 
 sprflechabrillo={{0,80},{16,80},{24,80},{8,80},{32,80},{40,80}}
 sprvuelta={{0,88},{8,88},{16,88}}
 sprvuelta2={{24,88},{32,88},{40,88}}
 sprbandera={
  {0,96},{16,96},{32,96},
  {0,112},{16,112},{32,112}}
 sprbanderaencendida={
  {48,96},{64,96},{48,112},{64,112}}

 --datos de la vegetacion
 nposicionvegetacion=5
 posicionvegetacion={2,18,38,58,78}
 nvegetacion=15
 vegetacion={{}}
 
 --dibujar camello en modo turbo
 turbo=0
 
 ---letras para los records
 letrasrecord="abcdefghijklmnopqrstuvwxyz0123456789!?-."
 
 --record actual
 cartdata("ganso_camellos_3")
 recordpuntos=dget(0)
 recordsegundos=dget(1)
 recordnombre1=dget(2)
 recordnombre2=dget(3)
 recordnombre3=dget(4)
 if recordpuntos==0 then recordpuntos=10 end
 if recordsegundos==0 then recordsegundos=60.0 end
 if recordnombre1==0 then recordnombre1=1 end
 if recordnombre2==0 then recordnombre2=1 end
 if recordnombre3==0 then recordnombre3=1 end
 recordnombre=
  sub(letrasrecord,recordnombre1,recordnombre1)..
  sub(letrasrecord,recordnombre2,recordnombre2)..
  sub(letrasrecord,recordnombre3,recordnombre3)
end

function initmenu()
 modo=1
 music(11)
 
 --datos de cada corredor
 ncorredores=4
 posiciony={18,38,58,78}
 corredor={}
 --inicializa los corredores
 for i=1,ncorredores do
  corredor[i]={
   -1, --x
   posiciony[i], --y
   1+flr(rnd(4)), --paso
   -1, --spr
   -1, --nombre
   0, --puntuacion
   0 } --segundos acumulados
  darnombrecorredor(i)
  darsprcorredor(i)
 end  

 --numero de corredor que es el jugador
 jugador=1
end 

function drawmenu()
 --rectfill(0,0,127,127,9)
 map(48,0,0,0,16,16)
 for n=1,ncorredores do
  dibujarcamello(n)
 end
 printcenter(texto[5][idioma],4,1)
 printcenter(texto[34][idioma],110,6)
 printcenter(recordnombre.." - "..recordpuntos..texto[35][idioma]..adecimales(recordsegundos)..texto[36][idioma],118,8)
end

function updatemenu()
 if btn(2) then
  jugador-=1
  if jugador<1 then jugador=4 end
 elseif btn(3) then
  jugador+=1
  if jugador>4 then jugador=1 end
 end
 
 while btn(1) or btn(2) or btn(3) or btn(0) do
  flip()
 end
 
 if btn(4) or btn(5) then
  while btn(4) or btn(5) do flip() end
  dificultad=1
  initcarrera()
 end
 
end

function initcarrera()
 modo=2
 music(-1)
 
 --inicializar corredores
 for i=1,ncorredores do
  corredor[i][1]=127
 end
 
 --semaforo: 4 (inicial), 3,2,1,0 empieza
 semaforo=4

 --iniicializar podium
 primero=-1
 segundo=-1
 tercero=-1
 
 --inicializa la posicion de la bandera
 posbandera=1
 banderaencendida=false
 
 --indica si un jugador ha terminado
 terminado={false,false,false,false}

 --vegetacion[sprite,x,posiciony]
 for n=1,nvegetacion do
  vegetacion[n]={
   1+flr(rnd(nsprarbol)),
   flr(rnd(128)),
   1+flr(rnd(1+nposicionvegetacion))
   }
 end

 --contador de pasos (para scroll)
 contadorpasos=0

 --indicador de flecha actual
 --(0=iz,1=dc,2=ar,3=ab)
 flecha=-1
 inicializaflecha()
end

function _update()
 if modo==0 then
  updateportada()
 elseif modo==1 then
  updatemenu()
 elseif modo==2 then
  updatecarrera()
 elseif modo==3 then
  updatefincarrera()
 elseif modo==4 then
  updateresultados()
 end
end
 
function _draw()
 if modo==0 then
  drawportada()
 elseif modo==1 then
  drawmenu()
 elseif modo==2 then
  drawcarrera()
 elseif modo==3 then
  drawfincarrera()
 elseif modo==4 then
  drawresultados()
 end
end

function updatecarrera()

 if semaforo==0 then
	 --hacemos avanzar a todos los corredores
	 for n=1,ncorredores do
	  --si no ha terminado
	  if terminado[n]==false then
		  --para los no jugadores
		  if n!=jugador then
		   --avanza una de cada 4 veces
		   if rnd(4)<=1 then
		    --avanza segun la dificultad
			   corredor[n][1]-=rnd(1+dificultad/2)
			   --si el jugador principal ha avanzado, lo hacemos mas rapido
			   if terminado[jugador] then corredor[n][1]-=1 end
					 --cambia el numero de paso
				  corredor[n][3]-=1
					 if corredor[n][3]<1 then
					  corredor[n][3]=4
					 end
					end
		  end
		 end
		end 
	
	 if turbo>0 then --if1
	  --si estamos en modo turbo, avanzamos aunque no pulsemos
	  corredor[jugador][1]-=2
	  turbo-=1
	  banderaencendida=false
	 else	--else1
		 --si pulsamos la tecla, avanza nuestro corredor
	  if terminado[jugador]==false then --if2
			 for boton=0,5 do --for3
			  --comprueba cada boton
				 if btn(boton) and boton==flecha then --if4
				  dibujarflecha(true)
				  sfx(0)
			   if banderaencendida==true then --if5
 			   --si la bandera esta encendida, empezamos un turbo
 			   turbo=10
 			   sfx(26)
 			  else	--elseif5
			    --si no, hacemos el avance normal
		 		  corredor[jugador][1]-=3+flr(rnd(4))
					  --cambia el numero de pasos
					  corredor[jugador][3]-=1
						 if corredor[jugador][3]<1 then --if6
						  corredor[jugador][3]=4
						 end --endif6
					  --espera a que se deje de pulsar
					  while btn(boton) do --while7
					   flip()
					  end --endwhile7
					  inicializaflecha()
					 end --endif5
				 else --else4
			   --si hemos pulsado el boton adecuado
			   --pero no tocaba...
			   if btn(boton) then --if8
			 	  dibujarflecha(true)
			 	  sfx(1)
			 	  if corredor[jugador][1]<127 then --if9
	 		    if banderaencendida==false then
 	 		    corredor[jugador][1]+=5
 	 		   else
 	 		    --si la bandera estaba encendida, retrocede mas
 	 		    corredor[jugador][1]+=10
 	 		   end
	 		    flip()   
	 		   end --endif9
			   end --endif8
     end --endif4
				end --endfor3
		 end --endif2
  end --endif1

  --avanza la bandera
  if banderaencendida==false then
   if rnd(200)<1 then
    banderaencendida=true
   else
    if rnd(8)<1 then posbandera+=1 end
    if posbandera==7 then posbandera=1 end
   end
  else
   if rnd(50)<1 then banderaencendida=false end 
  end
  
	 --avanza la vegetacion
	 contadorpasos+=dificultad
	 if contadorpasos>=3 then
	  for n=1,nvegetacion do
	   vegetacion[n][2]+=1
	   if vegetacion[n][2]>128 then
	     vegetacion[n][1]=1+flr(rnd(nsprarbol))
	     vegetacion[n][2]=-20
	     vegetacion[n][3]=1+flr(rnd(1+nposicionvegetacion))
	   end
	  end
	  contadorpasos=0
	 end

  --comprueba si alguno ha ganado
  for n=1,4 do
   if corredor[n][1]<1 and terminado[n]==false then
		  --terminamos y contamos los segundos acumulados
    terminado[n]=true
    corredor[n][7]+=time()-contadortiempo
    if primero==-1 then
     sfx(18)
     primero=n
   	 tiempoprimero=time()-contadortiempo
    elseif segundo==-1 then
     sfx(18)
     segundo=n
   	 tiemposegundo=time()-contadortiempo
    else
     tercero=n
     for m=1,4 do
      if terminado[m]==false then
       --al ultimo le contamos 5 segundos mas
       corredor[m][7]+=5+time()-contadortiempo
      end
     end
     initfincarrera()
    end
   end
  end
 
  else
 
  if semaforo==4 then
   if btn(4) or btn(5) then
    semaforo=3
   end
  else
	  if semaforo>1 then
	   sfx(2)
	  else
	   sfx(3)
	  end
	  for i=1,25 do
	   flip()
	  end
	  semaforo-=1
	  if	semaforo==0 then
	   --empieza la carrera
	   music(3)
	   contadortiempo=time()
	   end
	 end
 end
end

function drawcarrera()
 map(0,0,0,0,16,16)

 dibujarbandera()
 
 for n=1,ncorredores do
  dibujarlineavegetacion(n)
  dibujarcamello(n)
 end
 dibujarlineavegetacion(ncorredores+1)

 if semaforo==4 then
  map(32,0,0,0,16,16)
  if dificultad==1 then
   printcenter(texto[12][idioma],38,7)
   printcenter(texto[13][idioma],50,7)
   printcenter(texto[14][idioma],62,7)
   printcenter(texto[2][idioma],76,8)
  elseif dificultad==2 then
   printcenter(texto[19][idioma],36,7)
   printcenter(texto[20][idioma],50,7)
   printcenter(texto[38][idioma],62,7)
   printcenter(texto[2][idioma],76,8)
  else
   printcenter(texto[21][idioma],46,7)
   printcenter(texto[23][idioma],58,7)
   printcenter(texto[2][idioma],76,8)
  end
 elseif semaforo==3 then
  circfill(64, 64, 34, 1)
  circfill(64, 64, 32, 8)
  clip(64,0,64,128)
  circfill(65, 64, 31, 7)
  clip(0,0,64,128)
  circfill(63, 64, 31, 2)
  clip()
  circfill(64, 64, 31, 8)
  printcenter(texto[7][idioma],62,7)
 elseif semaforo==2 then
  circfill(64, 64, 34, 1)
  circfill(64, 64, 32, 9)
  clip(64,0,64,128)
  circfill(65, 64, 31, 10)
  clip(0,0,64,128)
  circfill(63, 64, 31, 4)
  clip()
  circfill(64, 64, 31, 9)
  printcenter(texto[8][idioma],62,7)
 elseif semaforo==1 then
  circfill(64, 64, 34, 1)
  circfill(64, 64, 32, 3)
  clip(64,0,64,128)
  circfill(65, 64, 31, 11)
  clip(0,0,64,128)
  circfill(63, 64, 31, 5)
  clip()
  circfill(64, 64, 31, 3)
  printcenter(texto[9][idioma],62,7)
 else
  --la carrera ha empezado
  if terminado[jugador]==false then dibujarflecha(false) end
  dibujarvuelta()
  if primero!=-1 then
   if primero==jugador then color=8 else color=7 end
	  print(nombrecorredor[corredor[primero][5]]..": "..adecimales(tiempoprimero)..texto[33][idioma],8,110,color)
	  if segundo!=-1 then
    if segundo==jugador then color=8 else color=7 end
	  	print(nombrecorredor[corredor[segundo][5]]..": "..adecimales(tiemposegundo)..texto[33][idioma],8,120,color)
	  end
	 else
	   print(adecimales(time()-contadortiempo).." "..texto[33][idioma],8,110,7)
	 end
	end
end

function dibujarvuelta()
 print(texto[22][idioma],110-2*#texto[22][idioma],110,6)
 for n=1,3 do
  if dificultad!=n then
   sspr(sprvuelta[n][1],sprvuelta[n][2],8,8,90+n*8,117)
  else
   sspr(sprvuelta2[n][1],sprvuelta2[n][2],8,8,90+n*8,117)
  end
 end
end

function dibujarbandera()
 if banderaencendida==false then
  sspr(sprbandera[posbandera][1],sprbandera[posbandera][2],16,16,40,8)
 else
  nbandera=flr(rnd(4)+1)
  sspr(sprbanderaencendida[nbandera][1],sprbanderaencendida[nbandera][2],16,16,40,8)
 end
end

function initfincarrera()
 modo=3
 turbo=0
 music(-1)
 sfx(17)
 corredor[primero][6]+=10
 corredor[segundo][6]+=6
 corredor[tercero][6]+=3
end

function drawfincarrera()
 map(16,0,0,0,16,16)
 colorprimero=6
 colorsegundo=6
 colortercero=6
 textoprimero=nombrecorredor[corredor[primero][5]]
 textosegundo=nombrecorredor[corredor[segundo][5]]
 textotercero=nombrecorredor[corredor[tercero][5]]
 if jugador==primero then
  colorprimero=8
  textoprimero="● "..textoprimero.." ●"
 elseif jugador==segundo then
  colorsegundo=8
  textosegundo="● "..textosegundo.." ●"
 elseif
  jugador==tercero then colortercero=8
  textotercero="● "..textotercero.." ●"
 end
 printcenter(texto[10][idioma]..dificultad..texto[24][idioma],25,7)
 printcenter("1: "..textoprimero,40,colorprimero)
 printcenter("2: "..textosegundo,50,colorsegundo)
 printcenter("3: "..textotercero,60,colortercero)
 printcenter(texto[11][idioma],78,7)
end

function drawresultados()
 map(64,0,0,0,16,16)
 for n=1,4 do
  dibujarcamello(n)
  if n==jugador then
   color=8
  else
   color=0
  end
	 if n==primero then
	  x=64
	  y=31
	  texto0=texto[25][idioma]
	 elseif n==segundo then
	  x=35
	  y=81
	  texto0=texto[26][idioma]
	 elseif n==tercero then
	  x=92
	  y=81
	  texto0=texto[27][idioma]
	 end
  if n==primero or n==segundo or n==tercero then
	  texto1=nombrecorredor[corredor[n][5]]
	  texto2=corredor[n][6].." "..texto[28][idioma]
	  print(texto0,x-2*#texto0,y,color)
	  print(texto1,x-2*#texto1,y+8,color)
	  print(texto2,x-2*#texto2,y+16,5)
	 end
 end
 
 if jugador==primero then
  texto1=texto[29][idioma]
 elseif jugador==segundo then
  texto1=texto[30][idioma]
 elseif jugador==tercero then
  texto1=texto[31][idioma]
 else
  texto1=texto[32][idioma]
 end
 printcenter(texto1,114,7) 
 
 if nuevorecord==true then
  printcenter(texto[37][idioma],6,8+flr(rnd(3)))
  postexto=64-2*(#texto[39][idioma]+4)
  print(texto[39][idioma],postexto,14,2)
  postexto+=#texto[39][idioma]*4
  recordnombre=""
  for l=1,3 do
   letrachar=sub(letrasrecord,letra[l],letra[l])
   if nletra==l then colorchar=8+flr(rnd(3)) else colorchar=2 end
   print(letrachar,postexto,14,colorchar)
   postexto+=4
   recordnombre=recordnombre..letrachar
  end
  dset(0,recordpuntos)
  dset(1,recordsegundos)
  dset(2,letra[1])
  dset(3,letra[2])
  dset(4,letra[3])
 end
end

function updatefincarrera()
 if btn(4) or btn(5) then
   while btn(4) or btn(5) do
    flip()
   end
  if dificultad<3 then
   dificultad+=1
   initcarrera()
  else
   initresultados()
  end
 end
end

function initresultados()
 modo=4
 music(12)
 primero=-1
 segundo=-1
 tercero=-1

 for n=1,4 do
  if primero==-1 then
   primero=n
  elseif corredor[n][6]>corredor[primero][6] then
   primero=n
  elseif corredor[n][6]==corredor[primero][6] then
	  --empate: contamos por segundos acumulados
   if corredor[n][7]<corredor[primero][7] then
    primero=n
   end
  end
 end
 for n=1,4 do
  if n!=primero then
   if segundo==-1 then
    segundo=n
   elseif corredor[n][6]>corredor[segundo][6] then
    segundo=n
   elseif corredor[n][6]==corredor[segundo][6] then
		  --empate: contamos por segundos acumulados
    if corredor[n][7]<corredor[segundo][7] then
     segundo=n
    end
   end
  end
 end
 for n=1,4 do
  if n!=primero and n!=segundo then
	  if tercero==-1 then
	   tercero=n
	  elseif corredor[n][6]>corredor[tercero][6] then
	   tercero=n
	  elseif corredor[n][6]==corredor[tercero][6] then
		  --empate: contamos por segundos acumulados
	   if corredor[n][7]<corredor[tercero][7] then
     tercero=n
    end
	  end
  end
 end
 
 if corredor[jugador][6]>recordpuntos or (corredor[jugador][6]==recordpuntos and corredor[jugador][7]<recordsegundos) then
  nuevorecord=true
  letra={1,1,1}
  nletra=1
  recordpuntos=corredor[jugador][6]
  recordsegundos=corredor[jugador][7]
 else
  nuevorecord=false
 end

end

function updateresultados()
 if btn(4) or btn(5) then
  while btn(4) or btn(5) do
   flip()
  end
  initmenu()
 elseif btn(0) then
  sfx(12)
  if nletra>1 then nletra-=1 end
  flip()
  flip()
  flip()
 elseif btn(1) then
  sfx(12)
  if nletra<3 then nletra+=1 end
  flip()
  flip()
  flip()
 elseif btn(2) then
  sfx(12)
  if letra[nletra]<#letrasrecord then letra[nletra]+=1 else letra[nletra]=1 end
  flip()
  flip()
  flip()
 elseif btn(3) then
  sfx(12)
  if letra[nletra]>1 then letra[nletra]-=1 else letra[nletra]=#letrasrecord end
  flip()
  flip()
  flip()
 end
end

function printcenter(texto,y,color)
 print(texto,64-2*#texto,y,color)
end

function adecimales(n)
 entero=flr(n)
 decimales="."..flr(n%1*100)
 while #decimales<3 do
  decimales=decimales.."0"
 end
 return entero..decimales
end
__gfx__
0000000000000c1c10000000000000000000000000000000000000000000000000000000cccccccc0000027270000000ccccca9c9acccccccccccccc00000000
0000000000000c1c1c000000000000000000000000000000000000000000000000000000cccccccc0000027272000000ccca9caaaca9cccccccccccc00000000
00000000000000499aa00000000000000000000000000000000000000000000000000000cccccccc000000f88dd00000cc9caaaaaa9caccccccccccc00000000
0007070000000099a0000000000000000000000000000000000000000000000000000000cccccccc00000088d0000000cac9aaaaaaaac9cccccccccc00000000
0000700000000008e0000000000000000000000000000000000000000000000000000000cccccccc0000000b30000000c9aaaaaaaaaa9acccccccccc00000000
00070700000008888e000000000000000000000000000000000000000000000000000000cccccccc00000bbbb3000000acaaaa777aaaac9ccccccccc00000000
00000000000000008e000000004450000990000000445000099000000044500009900000cccccccc00000000b30000009aaaa77777aaaaaccccccccc00000000
000000000000000866e00000456500004444400045650000444440004565000044444000cccccccc0000000b55300000c9aaa77777aaaacccccccccc00000000
000000000000008688ee000095444004444444009544400444444400954440044444440099999999000000b5bb3300009aaaa77777aaaa9c0000000000000000
00000000000000868880000000044444444444400004444444444440000444444444444099999999000000b5bbb00000acaaaa777aaaacac0000000000000000
0000000000000006880000000000444444444444000044444444444400004444444444449999999900000005bb000000c9aaaaaaaaaaa9cc0000000000000000
000000000000000011000000000044544444544500004454444454450000445444445445999999990000000044000000cac9aaaaaaa9cacc0000000000000000
000000000000000110000000000444500000044500044450000004400000444000055440999999990000000440000000cc9ca9aaaaac9ccc0000000000000000
000000000000000000000000004400540000445000440550000054000055544000550440999999990000000000000000ccca9caa9c9acccc0000000000000000
000000000000000000000000044000044004405400444500000554400550004400000044999999990000000000000000cccccac9a9cccccc0000000000000000
000000000000000000000000440000004044000400044000000500440000000440000000999999990000000000000000cccccccccccccccc0000000000000000
00000000000008e8e000000000000a9a900000000000056560000000000000000000000011111111000001c1c0000000cccccccccccccccc0000000000000000
00000000000008e8e800000000000a9a9a0000000000056565000000000000000000000011111111000001c1c1000000cccccccccccccccc0000000000000000
00000000000000c556600000000000b882200000000000411cc00000000000000000000011111111000000f556600000cccccccccccccccc0000000000000000
000000000000005560000000000000882000000000000011c00000000000000000000000111111110000005560000000cccccccc7777776c0000000000000000
0000000000000003b0000000000000056000000000000001c00000000000000000000000111111110000000670000000c7776ccccccccccc0000000000000000
00000000000003333b0000000000055556000000000001111c0000000000000000000000111111110000066667000000cccccccccccccccc0000000000000000
00000000000000003b0000000000000056000000000000001c0000000000000000000000111111110000000067000000cccccccccccccccc0077600007700000
000000000000000377b0000000000005ee6000000000000199c000000000000000000000111111110000000688700000cccccccccccccccc7866000077777000
000000000000003733bb00000000005e556600000000001911cc00000000000000000000cc99cc990000006866770000cccccccccccccccc7677700777777700
0000000000000037333000000000005e555000000000001911100000000000000000000011cc11cc0000006866600000cccccccccccccccc0007777777777770
0000000000000007330000000000000e5500000000000009110000000000000000000000cc11cc110000000866000000cccc67777776cccc0000777777777777
000000000000000022000000000000003300000000000000440000000000000000000000111111110000000022000000cc67777776cccccc0000776777776776
000000000000000220000000000000033000000000000004400000000000000000000000111111110000000220000000cccccccccccccccc0007776000000776
000000000000000000000000000000000000000000000000000000000000000000000000111111110000000000000000cccccccccccccccc0077006700007760
000000000000000000000000000000000000000000000000000000000000000000000000111111110000000000000000cccccccccccccccc0770000770077067
000000000000000000000000000000000000000000000000000000000555555555555550111111110000000000000000cccccccccccccccc7700000070770007
000000000000000000000000000000000000000000000000000000b3333500000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000b333333330000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000003333333335000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000bbbbbb330000000b333333b335000000000000000000000000000000000000000000000000000000000000000000
0000000000bb50000000000000000000000bbb33333350000003333b333333300000000000000000000000000000000000000000000000000000000000000000
bbb30000bb303500000000000000000000b3333333333500000333333333335000000000000000000000000000000000000000000000000000000bbbbb350000
03333b0b3300000000000000000000000b3333333353335000b33333333333500000000000000000000000000000000000000000000000000000033333335000
0000333333bbb00000000000000000000333333b3333333500333633335533500000000000000000000000000000000000000000000000000000b33333333b00
000033333333350000000000000000003b33333333333b350b333663355333500000000000000000000000000000000000000000000000000000333338333350
000b335433003350000000000000000033333333333333330b33336655333350000000000000000000000000000000000000000000000000000b333333333350
0b33300443b00330000000000000000033333333533333330b333366553333500000000000000000000000000000000000000000000000000003338333333330
b3000004433000330000000000000000033344333333b33303333366553333000000000000000000000000000000000000000000000000000003333333333330
30000004533000030000000000000000033334433333333303333365533333000000000000000000000000000000000000000000000000000003333333338335
000000440030000000000000000000000333334433433333033b3366533333000000000000000000000000000000000000000000000000000000333343333333
000000450030000000000000000000000333b3343445333300333366533b35000000000000000000000000000000000000000000000000000000383443333333
0000004500300000000000000000000000333334444333b0003333565333300000000000000000000000000000000000000000000bb000000000033443833330
00000040000000000000000000000000003333344433333000033366533350000000000000000000000000000000000000000b553333b0000000033443333300
00000440000000000000000000000000000333334433330000003366533300000000000000000000000000000000000000003333335335000000000453333000
000004500000000000000000000000000000033445333000000000655300000000000000000000000000000000000000000b3333333333500000000450000000
0000045000000000000000000000000000000034450000000000006650000000000000000000000000000000000000000003333b3333b3500000000450000000
00000450000000000000000000000000000000044500000000000066500000000000000000000000000000000000000000035333333333300000000450000000
00000450000000000000000003b00000000000044500000000000056500000000000000000000000000000000000000000003333333333300000000440000000
000004500000300003000000b3b500000000000445000000000000665000000000000000b00000000003500000b0000000003b33335333000000000450000000
055554555553b550030300033333b000000555444455550000555666655550000030000030000000005533000350000000055333333335500000555455555500
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11288881188888110000000000000000000000000000000000aa0aa0aa0aa0aa0a90a90000000000000000000000000000000000000000000000000000000000
1128111111112811000000000000000000000000000000000a959559559559559559594000000000000000000000000000000000000000000000000000000000
112811111111281100000000000000000000000000000000a9541991991991991a91959400000000000000000000000000000000000000000000000000000000
11281111111128110000000000000000000000000000000095411111111111111111195900000000000000000000000000000000000000000000000000000000
11281111111128110000000000000000000000000000000009111111111111111111119000000000000000000000000000000000000000000000000000000000
112811111111281100000000000000000000000000000000a5a111111111111111111a5900000000000000000000000000000000000000000000000000000000
11281111111128110000000000000000000000000000000095911111111111111111195900000000000000000000000000000000000000000000000000000000
11288881188888110000000000000000000000000000000009111111111111111111119000000000000000000000000000000000000000000000000000000000
000000000006600000000000000620000000000000000000a5a111111111111111111a5a99999999999999999999999999999999999999999999999900000000
00682000000880000006880000688200006888006800068095911111111111111111195999999999999999999999999999999999999999999999999900000000
06820000000880000000688006888820068228800680680009111111111111111111119099999999999999999999999999999999999999999999999900000000
688888820208806068888888088888800820068000888000a5a111111111111111111a5a99999999999999999999999999999999999999999999999900000000
88888882082886806888888208088080082006800088800095911111111111111111195999999999999999995555555555555555999999999999999900000000
08820000068888800000682000088000088668200820820009111111111111111111119099999999999999995777777777777775999999999999999900000000
008820000068880000068200000880000088820082000820a5a111111111111111111a5a99999999999999995777777777777775999999999999999900000000
00000000000620000000000000022000000000000000000095911111111111111111195955555555555555555777777777777775999999999999999900000000
00000000000660000000000000065000000000000000000009111111111111111111119057777777777777755777777777777775555555555555555500000000
006750000007700000067700006775000067770067000670a5a111111111111111111a5a57777771177777755777777117777775577777711777777500000000
06750000000770000000677006777750067557700670670095911111111111111111195957777716617777755777771aa1777775577777199177777500000000
6777777505077060677777770777777007500670007770000911111111111111111111905777716666177775577771aaaa177775577771999917777500000000
777777750757767067777775070770700750067000777000a5a111111111111111111a5a5777716665177775577771aaa9177775577771999417777500000000
077500000677777000006750000770000776675007507500995a1aa1aa1aa1aa1aa1a59457777716517777755777771a91777775577777194177777500000000
00775000006777000006750000077000007775007500075004959555559559559559594057777771177777755777777117777775577777711777777500000000
00000000000650000000000000055000000000000000000000440440440440440440440055555555555555555555555555555555555555555555555500000000
cccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
c111211cc112211cc112211cc111711cc117711cc117711c00000000000000000000000000000000000000000000000000000000000000000000000000000000
c112211cc121121cc121121cc117711cc171171cc171171c00000000000000000000000000000000000000000000000000000000000000000000000000000000
c121211cc111121cc111211cc171711cc111171cc111711c00000000000000000000000000000000000000000000000000000000000000000000000000000000
c111211cc112211cc111121cc111711cc117711cc111171c00000000000000000000000000000000000000000000000000000000000000000000000000000000
c111211cc121111cc121121cc111711cc171111cc171171c00000000000000000000000000000000000000000000000000000000000000000000000000000000
c111211cc122221cc112211cc111711cc177771cc117711c00000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000
cc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccc000000000000000000000000000000000000000000000000
cc548ecccce8888ccc54888ecccce88ccc5488888ecccccccc549999cccc999ccc54ddddccccdddc000000000000000000000000000000000000000000000000
cc5488e88888888ccc548888e888888ccc54888888e8888ccc5499999999999ccc54dddddddddddc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc54888888e8888ccc5499999999999ccc54dddddddddddc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc54888888e8888ccc5499999999999ccc54dddddddddddc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc5488888888888ccc5499999999999ccc54dddddddddddc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc5488888888888ccc5499999999999ccc54dddddddddddc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc5488888888888ccc5499999999999ccc54dddddddddddc000000000000000000000000000000000000000000000000
cc54cc888888cccccc54cccc8888cccccc54ccccc488888ccc54cccc9999cccccc54ccccddddcccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000
cc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccc000000000000000000000000000000000000000000000000
cc5488888888eccccc548888eccce88ccc5488ecccce888ccc54eeeecccceeeccc54bbbbccccbbbc000000000000000000000000000000000000000000000000
cc5488888888e88ccc548888e888888ccc54888e8888888ccc54eeeeeeeeeeeccc54bbbbbbbbbbbc000000000000000000000000000000000000000000000000
cc5488888888e88ccc548888e888888ccc54888e8888888ccc54eeeeeeeeeeeccc54bbbbbbbbbbbc000000000000000000000000000000000000000000000000
cc5488888888e88ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc54bbbbbbbbbbbc000000000000000000000000000000000000000000000000
cc5488888888e88ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc54bbbbbbbbbbbc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc54bbbbbbbbbbbc000000000000000000000000000000000000000000000000
cc5488888888888ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc54bbbbbbbbbbbc000000000000000000000000000000000000000000000000
cc54cccccccc488ccc54ccccc4888ccccc54cccc48888ccccc54cccceeeecccccc54ccccbbbbcccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccc000000000000000000000000000000000000000000000000
__label__
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccca9c9acccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccca9caaaca9cccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc9caaaaaa9caccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccac9aaaaaaaac9cccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7776cccccccccccccccccccc9aaaaaaaaaa9acccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccacaaaa777aaaac9ccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc9aaaa77777aaaaaccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc9aaa77777aaaacccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc9aaaa77777aaaa9ccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccacaaaa777aaaacaccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc99ccccccccccccccccccccccccccccccccccccccccccccccccccccc9aaaaaaaaaaa9cccccccccccccccccc
cccccccccccccccccccccccc7777776ccccccccccc548888eccce88ccccccccccccccccccccccccccccccccccccccccccac9aaaaaaa9cacccccccccc7777776c
cccccccccccccccccccccccccccccccccccccccccc548888e888888ccccccccccccccccccccccccccccccccccccccccccc9ca9aaaaac9ccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc548888e888888cccccccccccccccccccccccccccccccccccccccccccca9caa9c9acccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc5488888888888ccccccccccccccccccccccccccccccccccccccccccccccac9a9cccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc5488888888888ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc5488888888888ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccc5488888888888ccccccccccccccccccccccccccccccccc1c1ccccccccccccccccccccccccccccccccccccc
cccc67777776cccccccccccccccccccccccccccccc54ccccc4888ccccccccccccccc6777cccccccccccccccc1c1cccccccccccccccccccccb33335cccccccccc
cc67777776cccccccccccccccccccccccccccccccc54cccccccccccccccccccccc6777777777776ccccccccc499aacccccccccccccccccb33333333ccccccccc
cccccccccccccccccccccccccccccccccccccccccc54cccccccccccccccccccccccccccccccccccccccccccc99accccccccccccccccccc3333333335cccccccc
cccccccccccccccccccccccccccccccccccbbbbbb334ccccccccccccccccccccccccccccccccccccccccccccc8eccccccccccccccccccb333333b335cccccccc
ccccccccccccccccccccccccccccccccccbbb3333335ccccccccccccccccccccccccccccccccccccccccccc8888eccccccccccccccccc3333b3333333ccccccc
cccccccccccccccccccccccccccccccccb33333333335ccccccccccccccccccccccccccccccccccccccc445ccc8e9ccccccccccbbbbb3333333333335ccccccc
99999999999999999999999999999999b33333333533359999999999999999999999999999999999994565999866e449999999933333b3333333333359999999
99999999999999999999999999999999333333b33333335999999999999999999999999999999999999544498688ee44999999b3333333363333553359999999
99999999999999999999999999999993b33333333333b35999999999999999999999999999999999999994448688844449999933333b33366335533355999999
99999999999999999999999999999993333333333333333999999999999999999999999999999999999999444688444444999b33333b33336655333355999999
99999999999999999999999999999993333333353333333999999999999999999999999999999999999999445411445445999333833b33336655333353999999
9999999999999999999999999999999933344333333b333999999999999999999999999999999999999994445119999449999333333333336655333333999999
99999999999999999999999999999999333344333333333999999999999999999999999999999999999944955999995499999333333333336553333333599999
9999999999999999999999999999999933333443343333399999999999999999999999999999999999994445999995544999993333433b336653333333399999
99999999999999999999999999999999333b334344533339999999999999999999999999999999999999944999999599449999383443333366533b3533399999
999999999999999999999999999999999333334444333b9999999999999999999999999999999999999555555555555559999993344333335653333333999999
99999999999999999999999999999999933333444333339999999999999999999999994449499944499999499944494499444943344333336653335339999999
99999999999999999999999999999999993333344333399999999999999999999999994949499994999999499949494949949949445333336653333399999999
99999999999999999999999999999999999933445333999999999999999999999999994449499994994449499944494949949949445949996553999999999999
99999999999999999999999999999999999993445999999999999999999999999999998e8e499994999999499949494949949949445949996655999999999999
99999999999999999999999999999999999999445999999999999999999999999999998e8e844944499999444949494449444949445499996655999999999999
99999999999999999999999999993b99999999445999999999999999999999999999999c55669999999999999999999999999999944999995654999999999999
999999999999999999993999999b3b59999999445999999999999999999999999999999556999999999999999999999999999999945999996655999999999999
9999999999999999999939399933333b99555444455559999999999999999999999999993b999999999999999999999999999955545555566665555559999999
99999999999999999999999999999999999999999999999999999999999999999999993333b99999999999999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999994459993b99999999999999999999999999999999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999994565999377b4499999999999999999999999999999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999999544493733bb449999999999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999444373334444999999999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999688999999999999999999999944473344444499999999999999999996889999999999999999999999999
99999999999999999999999999999999999999999999968899999999999999999999944542244544599999999999999999999688999999999999999999999999
99999999999999999999999999999999999999999688888889999999999999999999944422995544999999999999999996888888899999999999999999999999
99999999999999999999999999999999999999999688888829999999999999999995554499955944999999999999999996888888299999999999999999999999
99999999999999999999999999999999999999999999968299999999999999999955999449999994499999999999999999999682999999999999999999999999
99999999999999999999999999999999999999999999682999999999999999999999999944999999999999999999999999996829999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999955555555555555999999999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999888989998889999988898999888999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999898989999899999989898999898999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999888989999899888988898999888999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999898989999899999989898999898999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999898988898889999989898889565699999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999565659999999999999999999999999999999999999999
9999999999999999999999999999999999999999999999993599999b9999999999999999999999999999411cc999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999553399935999999999999999999999999999911c99999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999991c99999999999999999999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999999999999999999999991111c9999999999999999999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999999999999999999994459991c9999999999999999999999999999999999999999
9999999999999999999999999999999999999999999999999999999999999999999999999999994565999199c449999999999999999999999999999999999999
9999999999999999999999999999999999999999999999999999999999999999999999999999999544491911cc44999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999944419111444499999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999994449114444449999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999994454444454459999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999944454499994459999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999449954999944599999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999994499994499449549999999999999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999999999999999999445555554544555499999999999999999999999bb999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999b553333b9999999
99999999999999999999999999999999999999999999999999999999999999999999444949994449999949494449444944499449999999993333335335999999
999999999999999999999999999999999999999999999999999999999999999999994949499994999999494949499499499949999999999b3333333333599999
9999999999999999999999999999999999999999999999999999999999999999999944494999949944494499444994994499444999999993333b3333b3599999
99999999999999999999999999999999999999999999999999999999999999999999494949999499999949494949949272799949999999935333333333399999
99999999999999999999999999999999999999999993b99999999999999999999999494944494449999949494949949272724499999999993333333333399999
999999999999999999999999999999999993999999b3b599999999999999999999999999999999999999999999999999f88dd999999999993b33335333999999
9999999999999999999999999999999999939399933333b999999999999999999999999999999999999999999999999988d99999999999955333333335599999
9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999b399999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999bbbb39999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999445999b39999999999999999999999999999
9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999994565999b553449999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999954449b5bb3344999999999999999999999999
999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999444b5bbb444499999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999994445bb4444449999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999994454444454459999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999944454499994499999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999449559999954999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999444599999554499999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999995544555555555449999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999944494999444999999449444994494449444949499999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999949494999949999994999494949994949499949499999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999944494999949944494999444949994449449949499999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999949494999949999994999494949994949499949499999999999
999993b9999999999999999999999999999999999999999999999999999999999999999999999949494449444999999449494994494949499994499999999999
9999b3b599999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999993599999b999999999
99933333b99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999553399935999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99cc99
11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc
cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111711111117771777111111771777117711111111111111111111111111111111111111111111111111111111111111111611166616661111111111111
11111111711111117171717111117111711171111111111111111111111111111111111111111111111111111111111111111111611161616161111111111111
11111111777111117771717111117771771171111111111111111111111111111111111111111111111111111111111111111111611166616661111111111111
11111111717111117171717111111171711171111111111111111111111111111111111111111111111111111111111111111111611161616111111111111111
11111111777117117771777111117711777117711111111111111111111111111111111111111111111111111111111111111111666161616111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111cccccccccccccccccccccccc111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c111711cc112211cc112211c111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c117711cc121121cc121121c111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c171711cc111121cc111211c111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c111711cc112211cc111121c111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c111711cc121111cc121121c111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c111711cc122221cc112211c111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111cccccccccccccccccccccccc111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__map__
0909090909090909092c09090c0d09090000000000000000000000000000000000000000000000000000000000000000191919191919191919191919191919190909090909090909092c09090c0d0909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909092d09c0c109090909091c1d092d0086878787878787878787878787880000000000000000000000000000000000191919191919191919191919191919190909092d09090909090909091c1d092d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c3d090909d0d1093c2d0909090909090096979797979797979797979797980000000000000000000000000000000000191919191919191919191919191919193c3d0909090909093c2d090909090909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900969797979797979797979797979800000000000000000000000000000000001919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900969797979797979797979797979800868787878787878787878787878787881919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900969797979797979797979797979800969797979797979797979797979797981919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900969797979797979797979797979800969797979797979797979797979797981919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900969797979797979797979797979800969797979797979797979797979797981919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
191919191919191919191919191919190096979797979797979797979797980096979797979797979797979797979798191919191919191919191919191919191919191919999a9b9c19191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
191919191919191919191919191919190096979797979797979797979797980096979797979797979797979797979798191919191919191919191919191919191919191919a9aaabacadae1919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900969797979797979797979797979800a6a7a7a7a7a7a7a7a7a7a7a7a7a7a7a81919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900a6a7a7a7a7a7a7a7a7a7a7a7a7a800000000000000000000000000000000001919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900000000000000000000000000000000000000000000000000000000000000001919191919191919191919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0006000028020340203a0202c000000000c0000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000271501a1501a1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900001874025000260002600026000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900002b7702b7702b7702600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000000000000000000000000000000000000000000000000000000000000000000000000000000000018525000001a535000001c535000001d5350000020535000001d535000001c535000002053500000
011600000c515105150c515105150c515105150c515105150e515115150e515115150e515115150e5151151510515145151051514515105151451510515145150e515115150e515115150e515115150e51511515
010600000c235000000000000000132250000013235000000c255000000000000000132250000013235000050c235000000000000000132250000013235000000c25500000000000000013225000001323500000
0106000024455004002645500400284550040029455004002c45500400294550040028455004002c4550040024455004000040000400004000040000000000000000000000000000000000000000000000000000
0106000028455000002c4550000029455000002845500000264550000028455000002c45500000294550000024455000000000000000000000000000000000000000000000000000000000000000000000000000
010600000c0230000000000000000c023000000c02300605246550000000000000000c023000000c023246050c0530000000000000000c023000000c02324605246550000000000000000c023000000c02300000
0106000028455000002c455000002945500000264552645528455284002c455000002945500000284552845528455000002c455000052945500000264552645528455000002c4550000029455000002845528455
0106000028455284022c4552c4022945529402264552640226455284122c4552c412294552941228455284122e4552e4122b4552b412294552941228455284122645526412294552941226455264122945529412
010600002444018400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c00000c214000000000000000132140000013214000000c224000000000000000132240000013224000000c224000000000000000132240000013225000000c22400000000000000013224000001322500000
011000001852218512000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000
001000000c2120c2120c21400000132140000013214000000c2140c2120c2120c2120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011600000c115101150c115101150c115101150c115101150e115111150e115111150e115111150e1151111510115141151011514115101151411510115141150e115111150e115111150e115111150e11511115
011900001834018340183401834000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001c140000001c1400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000c15400100001000010010154001001315400100181541814018130181201315013140131301312010154001000010000100131540010018154001001d1541d1401d1301d12018150181401813018120
010c0000181540010000100001001c154001001f15400100241342413224132241322413224132241322413224122241222412224122241122411224112241122411200100001000010000100001000000000000
010601200c6050c6050c60500000000000000000000000000c6050c6050c60500000000000000000000000000c6150c6150c6550c6550c6050c6050c6050c6050c6050c6050c6050c60500000000000000000000
0106000000000000000000000000000000000000000000000c6150c6150c6150c6150c6250c6250c6250c6250c6350c6350c6350c6350c6550c6550c6550c6550c6650c6650c6650c6650c6750c6750c6750c675
010c00000c75400700007000070010754007001375400700187541874018730187201375013740137301372010754007000070000700137540070018754007001d7541d7401d7301d72018750187401873018720
010c0000187540070000700007001c754007001f75400700247342473224732247322473224732247322473224722247222472224722247122471224712247122471200000000000000000000000000000000000
010600000c6250c6250c6250c6250c6150c6150c6150c6150c6550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500000c5700e5701057011570135701557017570185701a5701c5701d5701f5702157023570245700050000500005000050000500000000000000000000000000000000000000000000000000000000000000
__music__
04 040d4344
03 05424344
01 060c0944
00 06070944
00 06470944
00 06080944
00 06470944
00 06070944
00 064c0944
00 060a0944
02 060b0944
03 05104344
01 13151744
05 14161844
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 51424344
01 040d4344
04 0e0f4344

