package koula.diallo.book.manage;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserResponse {
    private String firstname;
    private String lastname;
    private boolean accountLocked;
    private boolean enable;
}
