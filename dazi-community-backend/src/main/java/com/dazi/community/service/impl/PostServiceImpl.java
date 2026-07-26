package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.constant.BizConstant;
import com.dazi.community.entity.dto.CreatePostRequest;
import com.dazi.community.entity.dto.TopPostRequest;
import com.dazi.community.entity.po.*;
import com.dazi.community.mapper.*;
import com.dazi.community.service.CommunityService;
import com.dazi.community.service.PostService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class PostServiceImpl implements PostService {

    @Resource
    private PostInfoMapper postInfoMapper;
    @Resource
    private PostCommentMapper postCommentMapper;
    @Resource
    private PostLikeMapper postLikeMapper;
    @Resource
    private TopOrderMapper topOrderMapper;
    @Resource
    private CommunityService communityService;
    @Resource
    private CommunityManagerMapper communityManagerMapper;
    @Resource
    private ManagerIncomeLogMapper managerIncomeLogMapper;

    @Override
    @Transactional
    public PostInfo createPost(Long userId, CreatePostRequest request) {
        if (!communityService.isMember(userId, request.getCommunityId())) {
            throw new BusinessException(30002, "无社区准入权限");
        }

        PostInfo post = new PostInfo();
        post.setCommunityId(request.getCommunityId());
        post.setUserId(userId);
        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setImgList(request.getImgList());
        post.setCity(request.getCity());
        post.setAddress(request.getAddress());
        if (request.getStartTime() != null && !request.getStartTime().isEmpty()) {
            post.setStartTime(LocalDateTime.parse(request.getStartTime(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        }
        post.setBudget(request.getBudget());
        post.setPeopleNum(request.getPeopleNum() != null ? request.getPeopleNum() : 1);
        post.setTags(request.getTags());
        post.setScope(request.getScope() != null ? request.getScope() : 0);
        post.setStatus(0);
        post.setViewCount(0);
        post.setLikeCount(0);
        post.setCommentCount(0);
        postInfoMapper.insert(post);
        return post;
    }

    @Override
    public Page<PostInfo> getPostPage(Long communityId, int page, int size) {
        LambdaQueryWrapper<PostInfo> wrapper = new LambdaQueryWrapper<PostInfo>()
                .eq(PostInfo::getStatus, 0)
                .orderByDesc(PostInfo::getIsTop)
                .orderByDesc(PostInfo::getCreateTime);
        if (communityId != null) {
            wrapper.eq(PostInfo::getCommunityId, communityId);
        }
        return postInfoMapper.selectPage(new Page<>(page, size), wrapper);
    }

    @Override
    public PostInfo getPostDetail(Long id) {
        PostInfo post = postInfoMapper.selectById(id);
        if (post == null) {
            throw new BusinessException("帖子不存在");
        }
        post.setViewCount(post.getViewCount() + 1);
        postInfoMapper.updateById(post);
        return post;
    }

    @Override
    @Transactional
    public void likePost(Long userId, Long postId) {
        PostInfo post = postInfoMapper.selectById(postId);
        if (post == null) {
            throw new BusinessException("帖子不存在");
        }
        Long count = postLikeMapper.selectCount(
                new LambdaQueryWrapper<PostLike>()
                        .eq(PostLike::getPostId, postId)
                        .eq(PostLike::getUserId, userId));
        if (count > 0) {
            throw new BusinessException("已经点赞过了");
        }
        PostLike like = new PostLike();
        like.setPostId(postId);
        like.setUserId(userId);
        postLikeMapper.insert(like);
        post.setLikeCount(post.getLikeCount() + 1);
        postInfoMapper.updateById(post);
    }

    @Override
    @Transactional
    public void unlikePost(Long userId, Long postId) {
        postLikeMapper.delete(
                new LambdaQueryWrapper<PostLike>()
                        .eq(PostLike::getPostId, postId)
                        .eq(PostLike::getUserId, userId));
        PostInfo post = postInfoMapper.selectById(postId);
        if (post != null && post.getLikeCount() > 0) {
            post.setLikeCount(post.getLikeCount() - 1);
            postInfoMapper.updateById(post);
        }
    }

    @Override
    @Transactional
    public PostComment addComment(Long userId, Long postId, String content, Long parentId) {
        PostInfo post = postInfoMapper.selectById(postId);
        if (post == null) {
            throw new BusinessException("帖子不存在");
        }
        PostComment comment = new PostComment();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setContent(content);
        comment.setParentId(parentId != null ? parentId : 0);
        postCommentMapper.insert(comment);
        post.setCommentCount(post.getCommentCount() + 1);
        postInfoMapper.updateById(post);
        return comment;
    }

    @Override
    public Page<PostComment> getComments(Long postId, int page, int size) {
        return postCommentMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<PostComment>()
                        .eq(PostComment::getPostId, postId)
                        .orderByAsc(PostComment::getCreateTime));
    }

    @Override
    @Transactional
    public void deletePost(Long userId, Long postId) {
        PostInfo post = postInfoMapper.selectById(postId);
        if (post == null) {
            throw new BusinessException("帖子不存在");
        }
        if (!post.getUserId().equals(userId) && !communityService.isManager(userId, post.getCommunityId())) {
            throw new BusinessException(10002, "权限不足");
        }
        postInfoMapper.deleteById(postId);
    }

    @Override
    public Page<PostInfo> getUserPosts(Long userId, int page, int size) {
        return postInfoMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<PostInfo>()
                        .eq(PostInfo::getUserId, userId)
                        .orderByDesc(PostInfo::getCreateTime));
    }

    @Override
    @Transactional
    public PostInfo topPost(Long userId, TopPostRequest request) {
        PostInfo post = postInfoMapper.selectById(request.getPostId());
        if (post == null) {
            throw new BusinessException("帖子不存在");
        }
        if (!post.getUserId().equals(userId)) {
            throw new BusinessException(10002, "只能置顶自己的帖子");
        }

        double price;
        int topType = request.getTopType();
        Long managerId = null;

        if (topType == 0) {
            // Community top
            price = BizConstant.COMMUNITY_TOP_PRICE;
            // Find community manager for revenue share
            CommunityManager manager = communityManagerMapper.selectOne(
                    new LambdaQueryWrapper<CommunityManager>()
                            .eq(CommunityManager::getCommunityId, post.getCommunityId())
                            .eq(CommunityManager::getRole, 1));
            if (manager != null) {
                managerId = manager.getUserId();
            }
        } else {
            price = BizConstant.SITE_TOP_PRICE;
        }

        // Create top order
        TopOrder order = new TopOrder();
        order.setPostId(request.getPostId());
        order.setUserId(userId);
        order.setTopType(topType);
        order.setPrice(BigDecimal.valueOf(price));
        order.setHours(24);
        order.setPlatformRate(BigDecimal.valueOf(BizConstant.TOP_PLATFORM_RATE));
        order.setManagerRate(BigDecimal.valueOf(BizConstant.TOP_MANAGER_RATE));
        order.setManagerUserId(managerId);
        order.setPayStatus(1); // auto paid for demo
        topOrderMapper.insert(order);

        // Auto-generate manager income if applicable
        if (managerId != null && topType == 0) {
            BigDecimal managerAmount = BigDecimal.valueOf(price)
                    .multiply(BigDecimal.valueOf(BizConstant.TOP_MANAGER_RATE))
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
            ManagerIncomeLog incomeLog = new ManagerIncomeLog();
            incomeLog.setManagerUserId(managerId);
            incomeLog.setCommunityId(post.getCommunityId());
            incomeLog.setOrderType(0);
            incomeLog.setOrderId(order.getId());
            incomeLog.setAmount(managerAmount);
            incomeLog.setStatus(0);
            managerIncomeLogMapper.insert(incomeLog);
        }

        // Update post top status
        post.setIsTop(1);
        post.setTopExpireTime(LocalDateTime.now().plusHours(24));
        postInfoMapper.updateById(post);

        return post;
    }

    @Override
    public Page<PostInfo> getPublicPosts(int page, int size) {
        return postInfoMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<PostInfo>()
                        .eq(PostInfo::getStatus, 0)
                        .eq(PostInfo::getScope, 1)
                        .orderByDesc(PostInfo::getIsTop)
                        .orderByDesc(PostInfo::getCreateTime));
    }
}
