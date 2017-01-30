package biz.stillhart.xtext.parser.antlr;

import biz.stillhart.xtext.parser.antlr.internal.InternalGeneratorParser;
import org.antlr.runtime.Token;
import org.antlr.runtime.TokenSource;
import org.eclipse.xtext.parser.antlr.AbstractIndentationTokenSource;

/**
 * Defines terminals
 * 
 * @author Patrick Stillhart
 */
public class GeneratorTokenSource extends AbstractIndentationTokenSource {

	public GeneratorTokenSource(TokenSource delegate) {
		super(delegate);
	}

	@Override
	protected boolean shouldSplitTokenImpl(Token token) {
		return token.getType() == InternalGeneratorParser.RULE_WS;
	}

	@Override
	protected int getBeginTokenType() {
		return InternalGeneratorParser.RULE_BEGIN;
	}

	@Override
	protected int getEndTokenType() {
		return InternalGeneratorParser.RULE_END;
	}

}
