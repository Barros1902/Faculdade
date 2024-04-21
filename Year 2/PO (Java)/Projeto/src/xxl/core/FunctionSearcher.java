package xxl.core;

public class FunctionSearcher implements ContentVisitor  {
	private String _searchby;
	private Boolean _match = false;

	public Boolean getMatch(){

		return _match;
	}

	public void setMacth(Boolean match){

		_match = match;
	}
	public FunctionSearcher(String searchby){

		_searchby = searchby;
	}

	public void visitContent(Content content){}


		public void visitLiterals(Literals literals){}

			public void visitNum(Num num){}
			public void visitNull(NULL _null){}
			public void visitCharArray(CharArray chararray){}
			
		public void visitReference(Reference reference){}

		public void visitFunction(Function function){
			matchesSubString(function);
		}

			public void visitRangeFunction(RangeFunction rangefunction){}

				public void visitMax(Max max){
					matchesSubString(max);
				}

				public void visitAverage(Average average){
					matchesSubString(average);
				}
				public void visitConcat(Concat concat){
					matchesSubString(concat);
				}
				public void visitCoalesce(Coalesce coalesce){
					matchesSubString(coalesce);
				}
				public void visitProduct(Product product){
					matchesSubString(product);
				}
			
			public void visitBinaryFunction(BinaryFunction binaryfunction){
				matchesSubString(binaryfunction);
			}

				public void visitSUB(SUB sub){
					matchesSubString(sub);
				}
				public void visitADD(ADD add){
					matchesSubString(add);
				}
				public void visitDIV(DIV div){
					matchesSubString(div);
				}
				public void visitMUL(MUL mul){
					matchesSubString(mul);
				}

	public void matchesSubString(Function function){
		
		_match = function.getName().contains(_searchby);
	}
}
