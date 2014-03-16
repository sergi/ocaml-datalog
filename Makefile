NAME = ocaml-datalog

all:
	ocamlfind ocamlc -c datalog.mli
	ocamlfind ocamlc -c datalog.ml
	ocamlfind ocamlc -c datalog.ml
	ocamlfind ocamlc -c prover.ml
	ocamlyacc parser.mly
	ocamlfind ocamlc -c parser.mli
	ocamlfind ocamlc -c parser.ml
	ocamllex scanner.mll
	ocamlfind ocamlc -c scanner.ml
	ocamlfind ocamlc -c reader.mli
	ocamlfind ocamlc -c reader.ml
	ocamlfind ocamlc -c main.ml
	ocamlfind ocamlc -o datalog datalog.cmo prover.cmo parser.cmo scanner.cmo	\
reader.cmo main.cmo

test:
	./try

dist:
	DATE=`date --iso`; \
	find . -name .git -prune -o -print0 \
		| cpio -pmd0 ../$(NAME)-$${DATE}; \
	cd ..; \
	tar czf $(NAME)-$${DATE}.tar.gz $(NAME)-$${DATE}; \
	rm -rf $(NAME)-$${DATE}

clean:
	rm *.cmo
	rm *.cmi
	rm datalog
	rm parser.ml parser.mli scanner.ml
