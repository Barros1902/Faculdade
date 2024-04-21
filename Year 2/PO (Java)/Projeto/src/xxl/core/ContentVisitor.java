package xxl.core;

interface ContentVisitor {
	void visitContent(Content content);


		void visitLiterals(Literals literals);

			void visitNum(Num num);
			void visitNull(NULL _null);
			void visitCharArray(CharArray chararray);
			
		void visitReference(Reference reference);

		void visitFunction(Function function);

			void visitRangeFunction(RangeFunction rangefunction);

				void visitAverage(Average average);
				void visitConcat(Concat concat);
				void visitCoalesce(Coalesce coalesce);
				void visitProduct(Product product);
				void visitMax(Max max);
			
			void visitBinaryFunction(BinaryFunction binaryfunction);

				void visitSUB(SUB sub);
				void visitADD(ADD add);
				void visitDIV(DIV div);
				void visitMUL(MUL mul);




}
