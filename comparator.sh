#!/bin/bash

verbose='false'

usage() {
	echo -e "Programa para comparação de dois arquivos.\nBasta colocar dois arquivos em uma pasta e ao executar o programa será\nescaneado os diretórios a partir do diretótio em que se encontra o\nscript.\n\nFlags:\nv Modo verboso"
}

while getopts 'vh' flag; do
  case "${flag}" in
      v) verbose='true' ;;
      h) usage
		 exit 1 ;;
      *) usage
      	 exit 1 ;;
  esac
done

if $verbose; 
	then
		echo "Modo verboso habilitado"
fi

for i in $(find ~+ -type d)
do
	if $verbose; 
		then
			echo "Procurando por arquivos no diretório $i"
	fi
	files=`find $i -maxdepth 1 -type f -name '*.csv' -o -name '*.txt'`
	if [ -z "$files" ];
		then
			if $verbose; 
				then
					echo "Não foram encontrados arquivos"
			fi
		else
			if $verbose; 
				then
					echo -e "Arquivos encontrados : \n$files"
			fi
			readarray -t listOfFiles <<< "$files"
			size="${#listOfFiles[@]}"
			if [ $size -eq 1 ];
				then
					if $verbose; 
						then
							echo "Apenas um arquivo encontrado, pulando"
					fi
			elif [ $size -eq 2 ];
			firstFile=${listOfFiles[0]}
			secondFile=${listOfFiles[1]}
				then
					if $verbose; 
						then
							echo "Ordenando arquivos primeiro"
					fi
				firstFileSorted=ffsTemp."${firstFile#*.}"
				secondFileSorted=sfsTemp."${secondFile#*.}"
				sort -o $firstFileSorted $firstFile
				sort -o $secondFileSorted  $secondFile
				if $verbose;
					then
						echo "Agora comparando arquivos"
				fi
				DIFF=`diff -c $firstFileSorted $secondFileSorted`
				if [ -z "$DIFF" ];
					then
						if $verbose; 
							then
								echo "Não foram encontradas diferenças"
						fi
					else
						echo -e "Diferenças encontradas nos arquivos:\n$files\n$DIFF"
				fi
				if $verbose;
					then
						echo "Removendo arquivos temporários"
				fi
				rm $firstFileSorted
				rm $secondFileSorted
			else
				if $verbose; 
					then
						echo "Vários arquivos encontrados, pulando"
				fi
		fi
	fi
done


