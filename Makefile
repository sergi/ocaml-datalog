NAME = ocaml-datalog

all:
	ocamlfind ocamlc -linkpkg -thread -package core -c datalog.mli
	ocamlfind ocamlc -linkpkg -thread -package core -c datalog.ml
	ocamlfind ocamlc -linkpkg -thread -package core -c datalog.ml
	ocamlfind ocamlc -linkpkg -thread -package core -c prover.ml
	ocamlyacc parser.mly
	ocamlfind ocamlc -linkpkg -thread -package core -c parser.mli
	ocamlfind ocamlc -linkpkg -thread -package core -c parser.ml
	ocamllex scanner.mll
	ocamlfind ocamlc -linkpkg -thread -package core -c scanner.ml
	ocamlfind ocamlc -linkpkg -thread -package core -c reader.mli
	ocamlfind ocamlc -linkpkg -thread -package core -c reader.ml
	ocamlfind ocamlc -linkpkg -thread -package core -c main.ml
	ocamlfind ocamlc -linkpkg -thread -package core -o datalog datalog.cmo prover.cmo parser.cmo scanner.cmo	\
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
