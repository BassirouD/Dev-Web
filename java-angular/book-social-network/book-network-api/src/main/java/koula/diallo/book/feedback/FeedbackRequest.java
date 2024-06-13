package koula.diallo.book.feedback;

import jakarta.validation.constraints.*;

public record FeedbackRequest(
        @Positive(message = "200")
        @Min(value = 0, message = "201")
        @Max(value = 5, message = "202")
        Double note,
        @NotNull(message = "2003")
        @NotEmpty(message = "2003")
        @NotBlank(message = "2003")
        String comment,
        @NotNull(message = "204")
        Integer bookId
) {
}
