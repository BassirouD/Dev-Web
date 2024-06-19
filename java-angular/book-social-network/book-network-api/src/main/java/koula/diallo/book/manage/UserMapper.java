package koula.diallo.book.manage;

import koula.diallo.book.user.User;
import org.springframework.stereotype.Service;

@Service
public class UserMapper {
    public UserResponse toUserResponse(User user) {
        return UserResponse.builder()
                .firstname(user.getFirstname())
                .lastname(user.getLastname())
                .accountLocked(user.isAccountLocked())
                .enable(user.isEnable())
                .build();
    }
}
