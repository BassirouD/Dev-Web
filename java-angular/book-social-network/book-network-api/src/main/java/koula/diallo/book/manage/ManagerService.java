package koula.diallo.book.manage;

import koula.diallo.book.common.PageResponse;
import koula.diallo.book.user.User;
import koula.diallo.book.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ManagerService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public PageResponse<UserResponse> findAllUsers(int page, int size, Authentication connectedUser) {
        User user = ((User) connectedUser.getPrincipal());
        Pageable pageable = PageRequest.of(page, size, Sort.by("lastname").descending());
        Page<User> users = userRepository.findAllUsers(pageable, user.getId());
        List<UserResponse> userResponses = users.stream()
                .map(userMapper::toUserResponse)
                .toList();
        return new PageResponse<>(
                userResponses,
                users.getNumber(),
                users.getSize(),
                users.getTotalElements(),
                users.getTotalPages(),
                users.isFirst(),
                users.isLast()
        );
    }
}
