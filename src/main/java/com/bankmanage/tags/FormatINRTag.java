package com.bankmanage.tags;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.tagext.TagSupport;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;

public class FormatINRTag extends TagSupport {
    private static final long serialVersionUID = 1L;
    
    private double value;

    // Standard JavaBeans setter required by TagSupport reflection
    public void setValue(double value) {
        this.value = value;
    }

    @Override
    public int doStartTag() throws JspException {
        try {
            // Build the standard Indian Currency layout
            Locale indiaLocale = new Locale("en", "IN");
            NumberFormat inrFormat = NumberFormat.getCurrencyInstance(indiaLocale);
            
            // Format the double value passed into the JSP tag
            String formattedValue = inrFormat.format(value);
            
            // Output it directly to the JSP Writer stream
            pageContext.getOut().print(formattedValue);
            
        } catch (IOException e) {
            throw new JspException("Error formatting INR currency", e);
        }
        return SKIP_BODY;
    }
}
