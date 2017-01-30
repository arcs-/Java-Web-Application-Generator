package biz.stillhart.generator.util;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

public class MessageHelper {

    public static void create(String formId, FacesMessage.Severity severity, String summary, String detail) {
        FacesContext.getCurrentInstance().addMessage(formId, new FacesMessage(severity, summary, detail));
    }

    public static void createError(String content) {
        create(null, FacesMessage.SEVERITY_ERROR, content, "");
    }

    public static void createInfo(String content) {
        create(null, FacesMessage.SEVERITY_INFO, content, "");
    }

}